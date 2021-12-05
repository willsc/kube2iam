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

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "kube2iam" {
    name        = "kube2iam_assumeRole_policy_${var.cluster_name}"
    path        = "/"
    description = "Kube2IAM role policy for ${var.cluster_name}"

    policy = "${data.aws_iam_policy_document.kube2iam.json}"
}

data "aws_iam_policy_document" "kube2iam" {
    statement {
        sid = "1"

        actions = [
        "sts:AssumeRole",
        ]

        effect = "Allow"

        resources = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/kube2iam_${var.cluster_name}/*",
        ]
    }
}

output "kube2iam_arn" {
    value = "${aws_iam_policy.kube2iam.arn}"
}

output "kube2iam_path" {
    value = "/kube2iam_${var.cluster_name}/"
}

