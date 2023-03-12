resource "aws_instance" "instance" {
    count           = "${var.instance_number}"
    ami             = "ami-xxxxxx"
    instance_type   = "${var.instance_type}"
    security_groups = "${concat(list("sg-xxxxxx"),var.security_groups)}"
    disable_api_termination = "${var.termination_protection}"
    subnet_id       = "${var.subnet_id}"
    iam_instance_profile = "test_role"
    tags {
            Name        = "prod-${var.cluster_name}-${var.service_name}-${count.index+1}"
            Environment = "prod"
            Product     = "${var.cluster_name}"
    }
    lifecycle {
        ignore_changes = [ "tags.LaunchedBy" ]
    }
    provisioner "local-exec" {
        command = <<EOF
launched_by=`aws iam get-user --profile prod | python -mjson.tool | grep UserName | awk '{print $2;exit; }'`
aws ec2 create-tags --resources ${self.id} --tags Key=LaunchedBy,Value=$${launched_by}
EOF
    }
}