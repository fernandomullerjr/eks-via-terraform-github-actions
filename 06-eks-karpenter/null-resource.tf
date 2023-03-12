resource "null_resource" "exec" {
  provisioner "local-exec" {
    command = "echo 'Hello, World!' > /tmp/output.txt"
  }
}

data "terraform_remote_state" "exec" {
  backend = "local"

  config = {
    path = "${path.root}/terraform.tfstate"
  }

  depends_on = [
    null_resource.exec
  ]
}

output "exec_output" {
  value = "${data.terraform_remote_state.exec.outputs.output}"
}
