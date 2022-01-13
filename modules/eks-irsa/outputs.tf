output "name" {
  description = "IAM Role name."
  value       = module.this.name
}

output "arn" {
  description = "The ARN assigned by AWS for this role."
  value       = module.this.arn
}

output "unique_id" {
  description = "The unique ID assigned by AWS."
  value       = module.this.unique_id
}

output "description" {
  description = "The description of the role."
  value       = module.this.description
}

output "mfa_required" {
  description = "Whether MFA should be required to assume the role."
  value       = var.mfa_required
}

output "mfa_ttl" {
  description = "Max age of valid MFA (in seconds) for roles which require MFA."
  value       = var.mfa_ttl
}

output "effective_date" {
  description = "Allow to assume IAM role only after this date and time."
  value       = var.effective_date
}

output "expiration_date" {
  description = "Allow to assume IAM role only before this date and time."
  value       = var.expiration_date
}

output "source_ip_whitelist" {
  description = "A list of source IP addresses or CIDRs allowed to assume IAM role from."
  value       = var.source_ip_whitelist
}

output "source_ip_blacklist" {
  description = "A list of source IP addresses or CIDRs denied to assume IAM role from."
  value       = var.source_ip_blacklist
}

output "assumable_roles" {
  description = "List of ARNs of IAM roles which members of IAM role can assume."
  value       = var.assumable_roles
}

output "policies" {
  description = "List of ARNs of IAM policies which are atached to IAM role."
  value       = var.policies
}

output "inline_policies" {
  description = "List of names of inline IAM polices which are attached to IAM role."
  value       = keys(var.inline_policies)
}
