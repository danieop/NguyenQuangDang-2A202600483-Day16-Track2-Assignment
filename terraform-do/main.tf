resource "digitalocean_droplet" "cpu_node" {
  name   = var.droplet_name
  region = var.region
  size   = var.droplet_size
  image  = var.image

  user_data = file("${path.module}/user_data.sh")

  tags = ["ai", "cpu", "fallback"]
}

resource "digitalocean_firewall" "cpu_api_fw" {
  name = "${var.droplet_name}-fw"

  droplet_ids = [digitalocean_droplet.cpu_node.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8000"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
