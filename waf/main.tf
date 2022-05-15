resource "aws_wafv2_web_acl" "waf" {
  name  = var.acl_name
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.acl_name
    sampled_requests_enabled   = true
  }

  # a rule to make a list of safe paths and block anything goes against it
  rule {
    name     = "safe_paths"
    priority = 0

    action {
      block {}
    }

    statement {
      and_statement {
        dynamic "statement" {
          for_each = var.safe_paths
          content {
            not_statement {
              statement {
                byte_match_statement {
                  field_to_match {
                    uri_path {}
                  }
                  positional_constraint = "STARTS_WITH"
                  search_string         = statement.value
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }
            }
          }
        }
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "safe_paths"
    }
  }

  # some aws managed rules
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # rate limiting rule
  rule {
    name     = "rate_limit"
    priority = 3

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.waf_rate_limit
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "rate_limit"
    }
  }
}

resource "aws_wafv2_web_acl_association" "waf" {
  resource_arn = var.resource_arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}
