###################################################
# Scanning Configuration
###################################################

resource "aws_ecr_account_setting" "basic_scan_type_version" {
  region = var.region

  name  = "BASIC_SCAN_TYPE_VERSION"
  value = var.scanning_basic_version
}

resource "aws_ecr_registry_scanning_configuration" "this" {
  region = var.region

  scan_type = var.scanning_type

  dynamic "rule" {
    for_each = var.scanning_rules

    content {
      scan_frequency = rule.value.frequency

      dynamic "repository_filter" {
        for_each = rule.value.filters
        iterator = filter

        content {
          filter_type = filter.value.type
          filter      = filter.value.value
        }
      }
    }
  }
}
