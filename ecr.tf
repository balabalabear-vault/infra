resource "aws_ecr_repository" "vault_frontend" {
  name                 = "vault-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}