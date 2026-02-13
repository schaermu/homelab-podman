# generated ansible inventory
# created: ${timestamp()}

${bastion.name} ansible_host=${bastion.ip}
${podman.name} ansible_host=${podman.ip}

[dns]
${dns_primary.name} ansible_host=${dns_primary.ip}

[nas]
nas-main ansible_host=192.168.1.40
