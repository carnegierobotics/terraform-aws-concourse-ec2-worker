output "worker_security_group_id" {
  description = "Security group ID used for the worker instances"
  value       = aws_security_group.default.id
}

output "worker_iam_role" {
  description = "Role name of the worker instances"
  value       = aws_iam_role.default.name
}

output "worker_iam_role_arn" {
  description = "Role ARN of the worker instances"
  value       = aws_iam_role.default.arn
}
