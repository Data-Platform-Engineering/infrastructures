output "redshift_endpoint" {
  value = aws_redshift_cluster.redshift_cluster.endpoint
}

output "redshift_cluster_id" {
  value = aws_redshift_cluster.redshift_cluster.id
}

output "redshift_security_group_id" {
  value = aws_security_group.redshift_sg.id
}
