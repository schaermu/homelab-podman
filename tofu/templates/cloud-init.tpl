#cloud-config
timezone: Europe/Zurich
users:
- name: ansible
  sudo: ALL=(ALL) NOPASSWD:ALL
  groups:
  - sudo
  - adm
  home: /home/ansible
  shell: /bin/bash
  ssh-authorized-keys:
  %{for key in ssh_keys}
    - ${key}
  %{endfor}
- name: ${username}
  home: /home/${username}
  shell: /bin/bash
  ssh-authorized-keys:
  %{for key in ssh_keys}
    - ${key}
  %{endfor}
package_update: true
package_reboot_if_required: true
packages:
- qemu-guest-agent
runcmd:
- systemctl enable qemu-guest-agent
- systemctl start qemu-guest-agent