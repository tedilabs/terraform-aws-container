###################################################
# Pull-time Update Exclusions
###################################################

resource "aws_ecr_pull_time_update_exclusion" "this" {
  for_each = var.pull_time_update.excluded_principals

  region = var.region

  principal_arn = each.value
}
