variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "sgp1"
}

variable "droplet_name" {
  description = "CPU node droplet name"
  type        = string
  default     = "ai-cpu-fallback"
}

variable "droplet_size" {
  description = "CPU node droplet size"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "image" {
  description = "Droplet image"
  type        = string
  default     = "ubuntu-22-04-x64"
}
