output "instance_id_1" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server_master.id
}

output "instance_public_ip_1" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server_master.public_ip
}

output "instance_public_dns_1" {
  description = "Public DNS address of the EC2 instance"
  value       = aws_instance.app_server_master.public_dns
}

#output "instance_id_2" {
#  description = "ID of the EC2 instance"
#  value       = aws_instance.app_server2.id
#}
#
#output "instance_public_ip_2" {
#  description = "Public IP address of the EC2 instance"
#  value       = aws_instance.app_server2.public_ip
#}
#
#output "instance_public_dns_2" {
#  description = "Public DNS address of the EC2 instance"
#  value       = aws_instance.app_server2.public_dns
#}

# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.xmpp_client.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda.invoke_url
}

output "load_balancer_url" {
  description = "Load balancer URL"
  value       = aws_lb.lm-lb.dns_name
}
