output "aws-lb-policy-arn-1" {
  value = aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn
}

output "aws-lb-policy-arn-2" {
  value = aws_iam_policy.AWSLoadBalancerControllerAdditionalIAMPolicy.arn
}
