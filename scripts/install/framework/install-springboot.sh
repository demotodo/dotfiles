#!/usr/bin/env bash

sdk install springboot

sudo ln -s ~/.sdkman/candidates/springboot/current/shell-completion/bash/spring /etc/bash_completion.d/spring

# check
spring version
