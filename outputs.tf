output "site_bucket" {
  value = aws_s3_bucket.site.bucket
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.site.id
}

output "github_deploy_role_arn" {
  value = aws_iam_role.github_deploy.arn
}

output "lambda_url" {
  value = aws_lambda_function_url.comments_lambda
}

output "aws_ses_domain_identity_mail" {
  value = aws_ses_domain_identity.mail
}
