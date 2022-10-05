## Install

Refer to [](../../../scripts/install/ops/install-k8s-centos7.sh)

File `init-config.yaml`:
```yaml
apiVersion: kubeadm.k8s.io/v1beta2
clusterName: kubernetes
controllerManager: {}
dns:
  type: CoreDNS
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: k8s.gcr.io
kind: ClusterConfiguration
kubernetesVersion: v1.15.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}

```

```text
[vagrant@k8s-master ~]$ sudo kubeadm init --config=init-config.yaml
[init] Using Kubernetes version: v1.15.0
[preflight] Running pre-flight checks
        [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
        [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.2. Latest validated version: 18.09
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Activating the kubelet service
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8s-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.0.2.15]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8s-master] and IPs [10.0.2.15 127.0.0.1 ::1]
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8s-master] and IPs [10.0.2.15 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[kubelet-check] Initial timeout of 40s passed.
[apiclient] All control plane components are healthy after 41.010648 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.15" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8s-master as control-plane by adding the label "node-role.kubernetes.io/master=''"
[mark-control-plane] Marking the node k8s-master as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: d2q30h.pah92kvgy2de9dkz
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.2.15:6443 --token ooc53u.ndnookvavnkhmrfv \
    --discovery-token-ca-cert-hash sha256:9ca43380a4c0c269bcdafb2009112ab11a99ead44f1b6b592b585014844d4f95
[vagrant@k8s-master ~]$
```


```text
[vagrant@k8s-master ~]$ kubectl get -n kube-system configmaps
NAME                                 DATA   AGE
coredns                              1      28m
extension-apiserver-authentication   6      28m
kube-proxy                           2      28m
kubeadm-config                       2      28m
kubelet-config-1.15                  1      28m
[vagrant@k8s-master ~]$
```


```text
[vagrant@k8s-master ~]$ kubectl get nodes
NAME         STATUS     ROLES    AGE   VERSION
k8s-master   NotReady   master   31m   v1.15.3
[vagrant@k8s-master ~]$ kubectl describe node k8s-master
Name:               k8s-master
Roles:              master
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=k8s-master
                    kubernetes.io/os=linux
                    node-role.kubernetes.io/master=
Annotations:        kubeadm.alpha.kubernetes.io/cri-socket: /var/run/dockershim.sock
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Sun, 15 Sep 2019 01:44:32 +0000
Taints:             node.kubernetes.io/not-ready:NoExecute
                    node-role.kubernetes.io/master:NoSchedule
                    node.kubernetes.io/not-ready:NoSchedule
Unschedulable:      false
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Sun, 15 Sep 2019 02:15:18 +0000   Sun, 15 Sep 2019 01:44:24 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Sun, 15 Sep 2019 02:15:18 +0000   Sun, 15 Sep 2019 01:44:24 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Sun, 15 Sep 2019 02:15:18 +0000   Sun, 15 Sep 2019 01:44:24 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            False   Sun, 15 Sep 2019 02:15:18 +0000   Sun, 15 Sep 2019 01:44:24 +0000   KubeletNotReady              runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized
Addresses:
  InternalIP:  10.0.2.15
  Hostname:    k8s-master
Capacity:
 cpu:                4
 ephemeral-storage:  39269648Ki
 hugepages-2Mi:      0
 memory:             3880148Ki
 pods:               110
Allocatable:
 cpu:                4
 ephemeral-storage:  36190907537
 hugepages-2Mi:      0
 memory:             3777748Ki
 pods:               110
System Info:
 Machine ID:                 cbb3b8fa428b499fa6774b4458836837
 System UUID:                CBB3B8FA-428B-499F-A677-4B4458836837
 Boot ID:                    b3be9960-ba76-4b58-9fb9-81073a68f663
 Kernel Version:             3.10.0-957.27.2.el7.x86_64
 OS Image:                   CentOS Linux 7 (Core)
 Operating System:           linux
 Architecture:               amd64
 Container Runtime Version:  docker://19.3.2
 Kubelet Version:            v1.15.3
 Kube-Proxy Version:         v1.15.3
Non-terminated Pods:         (5 in total)
  Namespace                  Name                                  CPU Requests  CPU Limits  Memory Requests  Memory Limits  AGE
  ---------                  ----                                  ------------  ----------  ---------------  -------------  ---
  kube-system                etcd-k8s-master                       0 (0%)        0 (0%)      0 (0%)           0 (0%)         29m
  kube-system                kube-apiserver-k8s-master             250m (6%)     0 (0%)      0 (0%)           0 (0%)         30m
  kube-system                kube-controller-manager-k8s-master    200m (5%)     0 (0%)      0 (0%)           0 (0%)         30m
  kube-system                kube-proxy-d6jlq                      0 (0%)        0 (0%)      0 (0%)           0 (0%)         31m
  kube-system                kube-scheduler-k8s-master             100m (2%)     0 (0%)      0 (0%)           0 (0%)         30m
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                550m (13%)  0 (0%)
  memory             0 (0%)      0 (0%)
  ephemeral-storage  0 (0%)      0 (0%)
Events:
  Type    Reason                   Age                From                    Message
  ----    ------                   ----               ----                    -------
  Normal  NodeHasSufficientMemory  31m (x8 over 31m)  kubelet, k8s-master     Node k8s-master status is now: NodeHasSufficientMemory
  Normal  NodeHasNoDiskPressure    31m (x8 over 31m)  kubelet, k8s-master     Node k8s-master status is now: NodeHasNoDiskPressure
  Normal  NodeHasSufficientPID     31m (x7 over 31m)  kubelet, k8s-master     Node k8s-master status is now: NodeHasSufficientPID
  Normal  Starting                 31m                kube-proxy, k8s-master  Starting kube-proxy.
[vagrant@k8s-master ~]$
```

### convert master node to a working node

```bash
sudo kubectl taint nodes --all node-role.kubernetes.io/master-
```



## Uninstall

```text
[vagrant@localhost kubernetes]$ sudo kubeadm reset
[reset] Reading configuration from the cluster...
[reset] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[reset] WARNING: Changes made to this host by 'kubeadm init' or 'kubeadm join' will be reverted.
[reset] Are you sure you want to proceed? [y/N]: y
[preflight] Running pre-flight checks
[reset] Removing info for node "k8s-master" from the ConfigMap "kubeadm-config" in the "kube-system" Namespace
W0914 14:54:22.434161   21897 removeetcdmember.go:61] [reset] failed to remove etcd member: error syncing endpoints with etc: etcdclient: no available endpoints
.Please manually remove this etcd member using etcdctl
[reset] Stopping the kubelet service
[reset] Unmounting mounted directories in "/var/lib/kubelet"
[reset] Deleting contents of config directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]
[reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]
[reset] Deleting contents of stateful directories: [/var/lib/etcd /var/lib/kubelet /etc/cni/net.d /var/lib/dockershim /var/run/kubernetes]

The reset process does not reset or clean up iptables rules or IPVS tables.
If you wish to reset iptables, you must do so manually.
For example:
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X

If your cluster was setup to utilize IPVS, run ipvsadm --clear (or similar)
to reset your system's IPVS tables.

The reset process does not clean your kubeconfig files and you must remove them manually.
Please, check the contents of the $HOME/.kube/config file.
[vagrant@localhost kubernetes]$
```
