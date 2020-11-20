
==============***********Terraform-Modules************======================
* when we want to reuse scripts/resource/template we go for modules
* what ever the stuff we want to use reuse we have to create folder named with "modules" (mandatory)
* later in the next template we have to use module resource to cal here we pass if any variables or files req by that module
* Modules file structure
--modules
  -main.tf
  -var.tf
  -out.tf
  -script ...etc files
when we want to reuse module in current template
  module arc-aws {
  source = "C:/Users/santh/OneDrive/Desktop/Sep-Practice/Scripts/Terraform/Module/modules/arc-aws"
  (or)source = "./modules/arc-aws"
  we can use any of the above source type based on the usage
  and also pass req variables
  accesskey = ""
  secretkey = ""
  #  param  = value
  }

*** later we have to do terraform init to download the module files 


==============***********Terraform-Workspace************======================

* Terraform workspace can be used to create multiple environments.
* terraform workspace is nothing but createste same infra for diff env like DEV,QA with some diff vars
* Even if you are not using workspaces now terraform creates a workspace called default automatically
terraform workspace list ---> o/p default
cmnds:
terraform workspace --help
terraform workspace list
terraform workspace new 
terraform workspace select

Excersize: 
* copy some script to some folder and execute
	terraform init
* now create one new workspace by using below it automatically switches to that
	terraform workspace new Dev
	terraform workspace list
		-default
		-Dev
* now do terraform apply .
* Lets now create new workspace called as QA 
	Change the values in the terraform.tfvars file and execute terraform apply
* Now examine your aws account and you will be observing two networks created from same terraform folder with workspaces
* terraform.tfstate.d
	Now executing terraform apply will create a new folder under terraform.tfstate.d as Dev and as well newly creating workspaces also
* State files will be stored in terraform.tfstate.d folder.
* You can also extend your state files by using backends

Note:- the below syntax is to diffrentiate the resource under DEV,QA in AWS console 
	tags = {
        Name = "myvpc-${terraform.workspace}"
    }


===================*************Terraform-Backend****************===========================

* When multiple people in the team are trying to use terraform in parallel, 
  then to allow only one user to make changes to the resources can be given by state locking
* Default "backend" is local so the .tfstate file gets stored locally.
* But when you are working in a team, it makes sense to have the state file (.tfstate) stored at remote location. 

Terraform S3 Backend & State Locking with AWS S3 & DynamoDb:- 
* Create a S3 bucket and note the name
* Create a dynamo db table in aws with LockID key of type string 
	terraform {
    backend "s3"{
        bucket = "${var.statestoragelocations3}"
        key = "${var.statestoragekey}"
    } }
* If you dont want to create these manually, There is module which can help you with creation of s3 storage & 
  dynamo db tables. To do that please add the module as mentioned below 
  module s3_backend {
  source                      = "youngfeldt/backend-s3/aws"
  version                     = ">= 1.0.0"
  backend_s3_bucket           = "<bucket name which you want to create>"
  backend_dynamodb_lock_table = "<dynamo db lock table>"
  create_dynamodb_lock_table  = true
  create_s3_bucket            = true
  s3_key                      = "<state storage file key in s3>"
	}
  
terraform init -backend-config='dynamodb_table=<dynamodbtablename>' --backend-config='access_key=whatever' --backend-config='secret_key=whatever'

Now execute terraform apply command & carefully observe the console you can observe the state locking & your s3 bucket with a file to store state

Note: see below url to underdtand the backend
https://github.com/directdevops/Terraform/tree/master/awss3backend
