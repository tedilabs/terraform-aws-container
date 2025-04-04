variable "kubernetes_version" {
  description = "(Required) Desired Kubernetes version to search the official EKS AMIs for the EKS cluster."
  type        = string
  nullable    = false
}

variable "os" {
  description = <<EOF
  (Required) A configuration of OS (Operating System) to search EKS official AMIs. `os` block as defined below.
    (Required) `name` - A name of the OS (Operating System). Valid values are `amazon-linux`, `ubuntu`, `ubuntu-pro`.
    (Required) `release` - A release name of the OS.
      `amazon-linux` - Valid values are `2`, `2023`.
      `ubuntu` - Valid values are `18.04`, `20.04`, `22.04`, `24.04`, `26.04`.
      `ubuntu-pro` - Same with `ubuntu`.
  EOF
  type = object({
    name    = string
    release = string
  })
  nullable = false

  validation {
    condition     = contains(["amazon-linux", "ubuntu", "ubuntu-pro"], var.os.name)
    error_message = "Valid values for `os.name` are `amazon-linux`, `ubuntu`, `ubuntu-pro`."
  }
  validation {
    condition = anytrue([
      var.os.name == "amazon-linux" && contains(["2", "2023"], var.os.release),
      contains(["ubuntu", "ubuntu-pro"], var.os.name) && contains(["18.04", "20.04", "22.04", "24.04", "26.04"], var.os.release),
    ])
    error_message = "Valid values for `os.release` are `2`, `2023` when `os.name` is `amazon-linux`. Valid values for `os.release` are `18.04`, `20.04`, `22.04`, `24.04`, `26.04` when `os.name` is `ubuntu` or `ubuntu-pro`."
  }
}

variable "arch" {
  description = "(Optional) The type of the CPU architecture. Valid values are `amd64`, `arm64`. Defaults to `amd64`."
  type        = string
  default     = "amd64"
  nullable    = false

  validation {
    condition     = contains(["amd64", "arm64"], var.arch)
    error_message = "Valid values for `arch` are `amd64`, `arm64`."
  }
}
