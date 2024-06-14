resource "aws_dynamodb_table" "example" {
  name             = "ContactEmails"
  hash_key         = "CreatedAt"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "CreatedAt"
    type = "S"
  }

  tags = {
    Name        = "contact-emails"
    Environment = "production"
  }
}