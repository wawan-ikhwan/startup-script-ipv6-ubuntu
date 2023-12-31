#!/bin/bash

update_resolved_conf() {
  local dns_server="$1"

  # Check if the provided DNS server is already set
  if grep -q "^DNS=$dns_server" /etc/systemd/resolved.conf; then
    echo "DNS server is already set to $dns_server"
    return
  fi

  # Check if there is an uncommented line for DNS
  if grep -q '^DNS=' /etc/systemd/resolved.conf; then
    # If found, overwrite existing DNS server to the new DNS server
    sudo sed -i '/^DNS=/ s/=.*$/='"$dns_server"'/' /etc/systemd/resolved.conf 
  else
    # If not found, create a new DNS key with the specified DNS server
    echo "DNS=$dns_server" | sudo tee -a /etc/systemd/resolved.conf > /dev/null
  fi

  # Restart the systemd-resolved service
  sudo systemctl restart systemd-resolved
}

# Check if the user provided an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <dns_server>"
  exit 1
fi

# Call the function with the provided DNS server argument
update_resolved_conf "$1"
