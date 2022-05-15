output "arn_waf" {
  description = "arn of the acl"
  value       = aws_wafv2_web_acl.waf.arn
}
