data "aws_iam_policy_document" "assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = module.default_label.id
  description        = "Cross account key access role for Concourse workers"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      var.keys_bucket_arn,
      "${var.keys_bucket_arn}/*",
    ]
  }

  statement {
    actions = [
      "ec2:DescribeVolume*", # needed to query the status of the worker volume
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "default" {
  count  = var.cross_account_worker_role_arn != null ? 0 : 1 # Disable if accessing another AWS account through an assume role
  name   = module.default_label.id
  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "cross_account_worker" {
  count = var.cross_account_worker_role_arn != null ? 1 : 0 # Enable if accessing another AWS account through an assume role
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      var.cross_account_worker_role_arn
    ]
  }
}

module "cross_account_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.default_label.context
  attributes = compact(concat(var.attributes, ["cross", "account"]))
}

resource "aws_iam_role_policy" "cross_account_worker" {
  count  = var.cross_account_worker_role_arn != null ? 1 : 0 # Enable if accessing another AWS account through an assume role
  name   = module.cross_account_label.id
  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.cross_account_worker[0].json
}

resource "aws_iam_instance_profile" "default" {
  name = module.default_label.id
  role = aws_iam_role.default.id
}
