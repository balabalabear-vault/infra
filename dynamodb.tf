resource "aws_dynamodb_table" "example" {
  name         = "ContactEmails"
  hash_key     = "created_at"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "created_at"
    type = "S"
  }

  tags = {
    Name        = "contact-emails"
    Environment = "production"
  }
}

// Comments

resource "aws_dynamodb_table" "comments" {
  name         = "Comments"
  hash_key     = "created_at"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "created_at"
    type = "S"
  }

  tags = {
    Name        = "comments"
    Environment = "production"
  }
}