terraform {}

provider "aws" {
    region = "${var.aws_region}"
}

variable "aws_region" {
    description = "AWS Region you want to deploy it in"
    default     = "eu-west-1"
}

variable "cluster_name" {
    description = "Name of the cluster"
}

variable "instance_iam_role_arn" {
    description = "ARN of the instance IAM role"
}

resource "aws_iam_role" "test_role" {
    name = "test_role"
    path = "/kube2iam_${var.cluster_name}/"

    assume_role_policy = "${data.aws_iam_policy_document.test_role.json}"
}

data "aws_iam_policy_document" "test_role" {
    statement {
        sid = "1"

        actions = [
            "sts:AssumeRole",
        ]

        principals {
            type        = "AWS"
            identifiers = ["${var.instance_iam_role_arn}"]
        }
    }
}

resource "aws_iam_role_policy" "test_role_policy" {
    name = "test_policy"
    role = "${aws_iam_role.test_role.id}"

    policy = "${data.aws_iam_policy_document.test_role_policy.json}"
}

data "aws_iam_policy_document" "test_role_policy" {
    statement {
        sid = "1"

        actions = [
            "s3:ListAllMyBuckets",
        ]

        resources = [
            "*",
        ]
    }
}

output "test_role" {
    value = "${aws_iam_role.test_role.arn}"
}
