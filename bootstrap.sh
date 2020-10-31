#! /usr/bin/env bash
#
# Setup ansible. Optionally install puppet5, docker and docker-compose.
# Supports Ubuntu 16.04.
#
# Usage: bootstrap.sh
#
# Leo Chan
#
function install_ansible {
  useradd -m -u 8000 -s /bin/bash ansible || return
  echo '%ansible ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/ansible
  mkdir /home/ansible/.ssh
cat <<-KEY_STRING >> /home/ansible/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDgItEVmOsUC2XIbsUCk0yEplam+Q6e3XBRJitnCNaaiSeuBhJjESntta8u/at73bH8EGCevLElZh1VVVsa/QMEuLtpto6XkKTy/uiaiL5UY6GrXnqpbTjuucHkvwbJkfwLnUKs+hIXhSMz5YgEwZaDfX4Ve4QyllPBlPQJ2yzjOCTBfhAG+HCeoVKphyx2UzlyjqVVn5NrPA6NYEWj8YMnEZDaWl1bMWf6J33mHdfJiXG27/L+CyVIn/ilcvX5GZKRhuBoUPDdbxS5ZjGKODTLNKLoTbLnQUloSz1TzgMgi7EsoJTXt4UIMcDAf3iH+mglx82ROf+MQ8gNqeBEgObh
KEY_STRING
  chmod 0700 /home/ansible/.ssh
  chmod 0600 /home/ansible/.ssh/authorized_keys
  chown -Rv ansible.ansible /home/ansible/.ssh
  apt-get install python3-apt curl -y
}

function install_docker {
  apt-get remove docker docker-engine docker.io -y
  apt-get update
  apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
  apt-get update
  apt-get install docker-ce -y
}

function install_docker_compose {
  curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  curl -L https://raw.githubusercontent.com/docker/compose/1.21.2/contrib/completion/bash/docker-compose \
  -o /etc/bash_completion.d/docker-compose
}
install_ansible
install_docker
install_docker_compose

