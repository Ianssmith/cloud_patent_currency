resource "aws_emr_cluster" "emr_cluster" {
  name          = "EMRCluster"
  release_label = "emr-6.2.0"
  applications  = ["Hadoop", "Spark","Hive"]
  
  ec2_attributes {
    instance_profile = "EMR_EC2_DefaultRole"
    subnet_id        = "subnet-"
  }

  master_instance_group {
    instance_type  = "m1.small"
    instance_count = 1
  }

  core_instance_group {
    instance_type  = "m1.small"
    instance_count = 2
  }

  service_role = "EMR_DefaultRole"
  depends_on = [aws_s3_bucket.ian-patent-stock]
}
