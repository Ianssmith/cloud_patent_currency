resource "aws_iam_role_policy_attachment" "lambda_s3_attach"{
	role="iam_for_lambda_ian"
	policy_arn="arn:aws:iam::866934333672:policy/lambda_s3_put"
}
