resource "aws_iam_policy" "emr_get_s3"{
	name = "emr_get_s3"
	description = "a policy to give emr access to s3"
	
	policy=jsonencode({
		Version: "2012-10-17",
		Statement:[{
			Effect:"Allow",
			Action: "logs:*" ,
			Resource:"arn:aws:logs:*:*:*"
		},
		{
			Effect:"Allow",
			Action: "s3:*" ,
			Resource:[
				"arn:aws:s3:::ian-patent-stock",
				"arn:aws:s3:::ian-patent-stock/*"
			]
		}]
	})
}

resource "aws_iam_role" "custom_role" {
  name               = "emr_mrole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })

}

resource "aws_iam_instance_profile" "emr_pro" {
  name = "emr_pro"
  role = aws_iam_role.custom_role.name
}
resource "aws_iam_role_policy_attachment" "s3_emr_attach"{
	role = "aws_iam_role.custom_role.emr_pro"
	policy_arn = "arn:aws:iam::866934333672:policy/emr_get_s3"
}
resource "aws_emr_cluster" "ian-stock-cluster" {
  name          = "ian-stock-cluster"
  release_label = "emr-6.2.0"
  applications  = ["Hadoop", "Spark","Hive"]
  service_role = aws_iam_role.custom_role.arn
  ec2_attributes {
    instance_profile = "arn:aws:iam::866934333672:instance-profile/emr_mrole"
    subnet_id        = "subnet-10.0.0.0/16"
  }

  master_instance_group {
    instance_type  = "m5.xlarge"
    instance_count  = 1
  }

  core_instance_group {
    instance_type  = "m5.xlarge"
    instance_count  = 1
  }
}
