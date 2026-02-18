locals {
  tags = {
    Project   = "shopstack"
    Env       = "dev"
    ManagedBy = "terraform"
  }
}

resource "aws_ecr_repository" "catalog" {
  name                 = "shopstack-catalog"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "catalog" {
  repository = aws_ecr_repository.catalog.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = { type = "expire" }
    }]
  })
}
