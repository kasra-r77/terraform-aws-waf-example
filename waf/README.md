# WAF

This module creates a waf and associate it to the Amazon resource. the resource must be either an Application Load Balancer or API Gateway.

## Rules

3 types of rules can be found in the code:

- Regular rule (making a safe list of paths for our application)
- Amazon managed rules
- rate based rule
