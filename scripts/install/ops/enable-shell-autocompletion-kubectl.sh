#!/usr/bin/env bash

## Enabling shell autocompletion

mkdir -p /etc/bash_completion.d

sudo kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl
