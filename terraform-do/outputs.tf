output "droplet_ip" {
  description = "Public IPv4 address of the CPU node"
  value       = digitalocean_droplet.cpu_node.ipv4_address
}

output "health_url" {
  description = "Health endpoint"
  value       = "http://${digitalocean_droplet.cpu_node.ipv4_address}/health"
}

output "predict_url" {
  description = "Prediction endpoint"
  value       = "http://${digitalocean_droplet.cpu_node.ipv4_address}/predict"
}
