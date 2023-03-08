
output "current_arn_teste" {
  description = "Current ARN - TESTE."
  value       = data.aws_caller_identity.current.arn
}
