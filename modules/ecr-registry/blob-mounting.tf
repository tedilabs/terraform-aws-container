###################################################
# Blob Mounting
###################################################

resource "aws_ecr_account_setting" "blob_mounting" {
  region = var.region

  name  = "BLOB_MOUNTING"
  value = var.blob_mounting.enabled ? "ENABLED" : "DISABLED"
}
