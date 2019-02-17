data "aws_caller_identity" "current" {}

module "label" {
  source  = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.5.4"
  name    = "${var.name}"

  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  tags      = "${var.tags}"
  delimiter = "${var.delimiter}"
}

resource "aws_iam_role" "role" {
  name                 = "${module.label.id}"
  max_session_duration = "${var.role_max_session_duration_secs}"
  assume_role_policy   = "${data.aws_iam_policy_document.role_trust_current_account.json}"
  tags                 = "${module.label.tags}"
}

data "aws_iam_policy_document" "role_trust_current_account" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_group" "role" {
  name = "${module.label.id}"
}

resource "aws_iam_group_policy_attachment" "role" {
  group = "${aws_iam_group.role.name}"
  policy_arn = "${aws_iam_policy.assume_role.arn}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.role.*.arn}"]
  }
}

resource "aws_iam_policy" "assume_role" {
  name        = "${module.label.id}-permit-assume-role"
  description = "Allow assuming role ${module.label.id}"
  policy      = "${join("", data.aws_iam_policy_document.assume_role.*.json)}"
}

resource "aws_iam_role_policy_attachment" "role" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
