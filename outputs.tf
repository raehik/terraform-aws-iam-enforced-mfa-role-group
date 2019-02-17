output "group_arn" {
  value = "${aws_iam_group.role.arn}"
}

output "group_name" {
  value = "${aws_iam_group.role.name}"
}

output "role_arn" {
  value = "${aws_iam_role.role.arn}"
}

output "role_policy_arn" {
  value = "${aws_iam_policy.assume_role.arn}"
}
