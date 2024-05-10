#define IAM role
#define lambda
#create s3 bucket
# bucket: ian-patent-stock
# region: us-east-1

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

data "aws_iam_policy_document" "assume_role"{
	statement{
		effect = "Allow"
		principals {
			type = "Service"
			identifiers = ["lambda.amazonaws.com"]
		}
		actions = ["sts:AssumeRole"]
	}
}

resource "aws_iam_role" "iam_for_lambda_ian" {
  name           = "iam_for_lambda_ian"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name = "lambda_s3"
  }
}

data "archive_file" "lambda"{
	type="zip"
	source_file="${path.module}/src/alphav.py"
	output_path = "lambda_s3.zip"
}

resource "aws_lambda_function" "lambda" {
	filename = "lambda_s3.zip"
	function_name = "get_data_put_s3"
	role = aws_iam_role.iam_for_lambda_ian.arn

	runtime="python3.10"
	handler="alphav"
}

resource "aws_iam_policy" "lambda_s3_put"{
	name = "lambda_s3_put"
	description = "a policy to give lambda access to s3"
	
	policy=jsonencode({
		Version: "2012-10-17",
		Statement:[{
			Effect:"Allow",
			Action:[ "logs:*" ],
			Resource:"arn:aws:logs:*:*:*"
		},
		{
			Effect:"Allow",
			Action:[ "s3:*" ],
			Resource:[
				"arn:aws:s3:::ian-patent-stock",
				"arn:aws:s3:::ian-patent-stock/*"
			]
		}]
	})
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attach"{
	role = "iam_for_lambda_ian"
	policy_arn = "arn:aws:iam::866934333672:policy/lambda_s3_put"
}

