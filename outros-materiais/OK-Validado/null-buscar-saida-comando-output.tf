
resource "null_resource" "exec" {
  provisioner "local-exec" {
    command = "echo 'Hello, World!' > ${path.module}/output.txt"
  }
}

locals {
  null_resource_exec_stdout = chomp(file("${path.module}/output.txt"))

}

output "my_output" {
  value = local.null_resource_exec_stdout
}