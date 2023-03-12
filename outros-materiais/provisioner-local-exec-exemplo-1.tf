resource "aws_instance" "instance" {
    ami = "ami-123456"
    instance_type = "t2.micro"
    tags {
        Name = "HelloWorld"
    }
    lifecycle {
        ignore_changes = [ "tags.Owner" ]
    }
    provisioner "local-exec" {
        command = <<EOF
owner=`aws sts get-caller-identity --output text --query 'Arn' | cut -d"/" -f2`
aws ec2 create-tags --resources ${self.id} --tags Key=Owner,Value=$${owner}
EOF
    }
}