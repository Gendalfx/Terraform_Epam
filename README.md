# Project Description
The architecture of the project include:

VPC (Virtual Private Cloud)
2 x EC2 Instances
1 x Load Balancer

![](https://elearn.epam.com/assets/courseware/v1/f4fa5ac5a0dea7cde73b4afebff5ec7a/asset-v1:RD_CEE+DevOpsCloud+IaC_0123+type@asset+block/DevOps_S7_Scheme_1_v2.svg)

____

# How to launch a project
To run the project, you need to add your ACCESS_KEY and SECRET_KEY

For Windows:
```
$env:AWS_ACCESS_KEY_ID=" "
$env:AWS_SECRET_ACCESS_KEY=" "
```
Next you need to launch the terraform itself:

```
Terraform init
Terraform plan
Terraform apply
```
