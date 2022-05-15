variable "resource_arn" {
  # must be an ARN of an Application Load Balancer or an Amazon API Gateway.
  description = "ARN of the resource to associate with the waf"
  default     = "your ARN goes here"
}


variable "acl_name" {
  defualt = "aws-waf"
}

variable "safe_paths" {
  type    = list(string)
  default = ["/"]
}

variable "waf_rate_limit" {
  description = "threshold for number of requests a single ip can make in 5 minute time window"
  default     = 200
}
