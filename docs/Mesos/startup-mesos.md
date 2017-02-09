## etc

```
[vagrant@localhost default]$ ll /etc/default/
total 24
-rw-r--r--. 1 root root  372 Feb  8 05:02 grub
-rw-r-----. 1 root root   38 Apr 14  2016 mesos
-rw-r-----. 1 root root   35 Feb  8 06:37 mesos-master
-rw-r-----. 1 root root   51 Feb  8 06:37 mesos-slave
-rw-r--r--. 1 root root 1756 Dec  6 21:32 nss
-rw-r--r--. 1 root root  119 Nov  4 18:24 useradd
[vagrant@localhost default]$ ll /etc/mesos
total 4
-rw-r--r--. 1 root root 26 Apr 14  2016 zk
[vagrant@localhost default]$ ll /etc/mesos-master/
total 8
-rw-r--r--. 1 root root  2 Apr 14  2016 quorum
-rw-r--r--. 1 root root 15 Apr 14  2016 work_dir
[vagrant@localhost default]$ ll /etc/mesos-slave/
total 0
[vagrant@localhost default]$
```

## startup script

Script file `/usr/lib/systemd/system/mesos-master.service`:
```
[Unit]
Description=Mesos Master
After=network.target
Wants=network.target

[Service]
ExecStart=/usr/bin/mesos-init-wrapper master
Restart=always
RestartSec=20
LimitNOFILE=16384

[Install]
WantedBy=multi-user.target
```

Script file `/usr/lib/systemd/system/mesos-slave.service`:
```
[Unit]
Description=Mesos Slave
After=network.target
Wants=network.target

[Service]
ExecStart=/usr/bin/mesos-init-wrapper slave
KillMode=process
Restart=always
RestartSec=20
LimitNOFILE=16384
CPUAccounting=true
MemoryAccounting=true

[Install]
WantedBy=multi-user.target
```

### /usr/bin/mesos-init-wrapper

```bash
#!/bin/bash
set -o errexit -o nounset -o pipefail
function -h {
cat <<USAGE
 USAGE: mesos-init-wrapper (master|slave)

  Run Mesos in master or slave mode, loading environment files, setting up
  logging and loading config parameters as appropriate.

  To configure Mesos, you have many options:

 *  Set a Zookeeper URL in

      /etc/mesos/zk

    and it will be picked up by the slave and master.

 *  You can set environment variables (including the MESOS_* variables) in
    files under /etc/default/:

      /etc/default/mesos          # For both slave and master.
      /etc/default/mesos-master   # For the master only.
      /etc/default/mesos-slave    # For the slave only.

 *  To set command line options for the slave or master, you can create files
    under certain directories:

      /etc/mesos-slave            # For the slave only.
      /etc/mesos-master           # For the master only.

    For example, to set the port for the slave:

      echo 5050 > /etc/mesos-slave/port

    To set the switch user flag:

      touch /etc/mesos-slave/?switch_user

    To explicitly disable it:

      touch /etc/mesos-slave/?no-switch_user

    Adding attributes and resources to the slaves is slightly more granular.
    Although you can pass them all at once with files called 'attributes' and
    'resources', you can also set them by creating files under directories
    labeled 'attributes' or 'resources':

      echo north-west > /etc/mesos-slave/attributes/rack

    This is intended to allow easy addition and removal of attributes and
    resources from the slave configuration.

USAGE
}; function --help { -h ;}                 # A nice way to handle -h and --help
export LC_ALL=en_US.UTF-8                    # A locale that works consistently

function main {
  err "Please use \`master' or \`slave'."
}

function slave {
  local etc_slave=/etc/mesos-slave
  local args=()
  local attributes=()
  local resources=()
  # Call mesosphere-dnsconfig if present on the system to generate config files.
  [ -x /usr/bin/mesosphere-dnsconfig ] && mesosphere-dnsconfig -write -service=mesos-slave
  set -o allexport
  [[ ! -f /etc/default/mesos ]]       || . /etc/default/mesos
  [[ ! -f /etc/default/mesos-slave ]] || . /etc/default/mesos-slave
  set +o allexport
  [[ ! ${ULIMIT:-} ]]    || ulimit $ULIMIT
  [[ ! ${MASTER:-} ]]    || args+=( --master="$MASTER" )
  [[ ! ${IP:-} ]]        || args+=( --ip="$IP" )
  [[ ! ${LOGS:-} ]]      || args+=( --log_dir="$LOGS" )
  [[ ! ${ISOLATION:-} ]] || args+=( --isolation="$ISOLATION" )
  for f in "$etc_slave"/* # attributes ip resources isolation &al.
  do
    if [[ -f $f ]]
    then
      local name="$(basename "$f")"
      if [[ $name == '?'* ]]         # Recognize flags (options without values)
      then args+=( --"${name#'?'}" )
      else args+=( --"$name"="$(cat "$f")" )
      fi
    fi
  done
  # We allow the great multitude of attributes and resources to be specified
  # in directories, where the filename is the key and the contents its value.
  for f in "$etc_slave"/attributes/*
  do [[ ! -s $f ]] || attributes+=( "$(basename "$f")":"$(cat "$f")" )
  done
  if [[ ${#attributes[@]} -gt 0 ]]
  then
    local formatted="$(printf ';%s' "${attributes[@]}")"
    args+=( --attributes="${formatted:1}" )        # NB: Leading ';' is clipped
  fi
  for f in "$etc_slave"/resources/*
  do [[ ! -s $f ]] || resources+=( "$(basename "$f")":"$(cat "$f")" )
  done
  if [[ ${#resources[@]} -gt 0 ]]
  then
    local formatted="$(printf ';%s' "${resources[@]}")"
    args+=( --resources="${formatted:1}" )         # NB: Leading ';' is clipped
  fi

  if [[ "${args[@]:-}" == *'--no-logger'* ]]
  then
    local clean_args=()
    for i in "${args[@]}"; do
      if [[ "${i}" != "--no-logger" ]]; then
        clean_args+=( "${i}" )
      fi
    done
    /usr/sbin/mesos-slave "${clean_args[@]}"
  else
    logged /usr/sbin/mesos-slave "${args[@]:-}"
  fi
}

function master {
  local etc_master=/etc/mesos-master
  local args=()
  # Call mesosphere-dnsconfig if present on the system to generate config files.
  [ -x /usr/bin/mesosphere-dnsconfig ] && mesosphere-dnsconfig -write -service=mesos-master
  set -o allexport
  [[ ! -f /etc/default/mesos ]]        || . /etc/default/mesos
  [[ ! -f /etc/default/mesos-master ]] || . /etc/default/mesos-master
  set +o allexport
  [[ ! ${ULIMIT:-} ]]  || ulimit $ULIMIT
  [[ ! ${ZK:-} ]]      || args+=( --zk="$ZK" )
  [[ ! ${IP:-} ]]      || args+=( --ip="$IP" )
  [[ ! ${PORT:-} ]]    || args+=( --port="$PORT" )
  [[ ! ${CLUSTER:-} ]] || args+=( --cluster="$CLUSTER" )
  [[ ! ${LOGS:-} ]]    || args+=( --log_dir="$LOGS" )
  for f in "$etc_master"/* # cluster log_dir port &al.
  do
    if [[ -f $f ]]
    then
      local name="$(basename "$f")"
      if [[ $name == '?'* ]]         # Recognize flags (options without values)
      then args+=( --"${name#'?'}" )
      else args+=( --"$name"="$(cat "$f")" )
      fi
    fi
  done

  if [[ "${args[@]:-}" == *'--no-logger'* ]]
  then
    local clean_args=()
    for i in "${args[@]}"; do
      if [[ "${i}" != "--no-logger" ]]; then
        clean_args+=( "${i}" )
      fi
    done
    /usr/sbin/mesos-master "${clean_args[@]}"
  else
    logged /usr/sbin/mesos-master "${args[@]:-}"
  fi
}

# Send all output to syslog and tag with PID and executable basename.
function logged {
  local tag="${1##*/}[$$]"
  exec 1> >(exec logger -p user.info -t "$tag")
  exec 2> >(exec logger -p user.err  -t "$tag")
  exec "$@"
}

function msg { out "$*" >&2 ;}
function err { local x=$? ; msg "$*" ; return $(( $x == 0 ? 1 : $x )) ;}
function out { printf '%s\n' "$*" ;}

if [[ ${1:-} ]] && declare -F | cut -d' ' -f3 | fgrep -qx -- "${1:-}"
then "$@"
else main "$@"
fi
```
