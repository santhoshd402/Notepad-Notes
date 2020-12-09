============*******************TERRAFORM**************===================
DEF: Use Infrastructure as Code(IAC) to provision and manage any cloud, infrastructure, or service

> Application Built by org was designed to work on various virtual environments like AWS, Azure, GCP 
> now qa wants to test those env. they require
> Cf for aws, ARM template for Azure, some othr for GCP
> But IF there is a tool to work on all cloud is best practise that is Terraform

Provider: Provider in Terraform will provide underlying interactions and exposes resources and Datasources to Terraform.
          To put it in simple representation Provider is where you want infra to be created
		  provider "dest-cloud"{
    region      = ""
    access_key  = ""
    secret_key  = ""
}
Resource: Infrastructure element which you are creating

resource "type" "name" {
     Required Arguments
	 name 	= "value"
	 name.n = "value"
}
ADV:
can manage deploying applications /infrastructure without downtime.
How is steve going to do that? Steve needs to know about
* Blue-Green Deployment
* Canary Deployments
* A/B

=============**************TERRAFORM_FILE**************=====================
* one imp thing is we never hardcode credentials in script we have varioues opitons here:
By using ENV-Variable:
	In Windows:
	$env:AWS_ACCESS_KEY_ID = "anaccesskey"
	$env:AWS_SECRET_ACCESS_KEY = "asecretkey"
	$env:AWS_DEFAULT_REGION = "ap-south-1"
    In Linux:
	export AWS_ACCESS_KEY_ID="anaccesskey"
	export AWS_SECRET_ACCESS_KEY="asecretkey"
	export AWS_DEFAULT_REGION="us-west-2"
By using Shared file:
	The default location is $HOME/.aws/credentials on Linux and macOS, 
						or "%USERPROFILE%\.aws\credentials" on Windows

commands:
terraform validate
terraform plan -out=sample.json
terraform apply -auto-approve sample.json

terraform taint <address> --> to recreate the only resourse remianing wont changes
terraform taint aws_instance.web1

Terraform configuration has many options like:
* LocalVaribles: used in script for resusebilty life is in script only

	locals {
	common_tags = {Name  = "FromTF_Automation"}
	}
	using --> tags=local.common_tags
	
	>>> also supports concatination:
	locals {
	# Ids for multiple sets of EC2 instances, merged together
	instance_ids = concat(aws_instance.blue.*.id, aws_instance.green.*.id)
	}
	
* InputVariables: inputs to the script we have so many types here
	[string,number,bool,list,set,map,object,tuple]
	Syntax:
	variable "anyname" {
	type1 = string
	type2 = list(string)
	default = ["us-west-1a"]
	type3 = list(object({
		internal = number
		external = number
		protocol = string
	}))
	default = [
		{
		internal = 8300
		external = 8300
		protocol = "tcp"
		}
	]
	}
  object(...): a collection of named attributes that each have their own type.
  tuple(...): a sequence of elements identified by consecutive whole numbers starting with zero, where each element has its own type.
  tuple([string, number, bool]
  =====Imp====
	terraform apply -var="image_id=ami-abc123" -var='image_id_list=["ami-abc123","ami-def456"]'
	terraform apply -var='image_id_map={"us-east-1":"ami-abc123","us-east-2":"ami-def456"}'
	* -var option can be used any number of times in a single command
	
	terraform apply -var-file="testing.tfvars"
	>>> Any files with names ending in .auto.tfvars or .auto.tfvars.json
	
Note:- validation
   validation {
	condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
	error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
   }
   COUNT:-
   1. resource "aws_instance" "server" {
      count = 4
   2. variable "subnet_ids" {
		type = list(string)
	  USAGE:
	  count = length(var.subnet_ids)
	  subnet_id = var.subnet_ids[count.index]

COUNT & FOREACH:-
	If your resource instances are almost identical, count is appropriate. 
	If some of their arguments need distinct values that can't be directly derived from an integer, it's safer to use for_each.
	
* OutputVariables: after script completion we need some output values like: publicip, vpcid, publicdns
  output "db_password" {
	value       = aws_db_instance.db.password 
	description = "The password for logging in to the database."
	sensitive   = true
  }
******* https://www.terraform.io/docs/configuration/variables.html
		https://www.terraform.io/docs/configuration/resources.html

Mainly focused commands Init,Validate,Plan,Apply,destroy,fmt,graph,taint

-target=resource       Resource to target. Operation will be limited to this
The terraform get command is used to download and update modules mentioned in the root module.
resource and its dependencies. This flag can be used multiple times.

=================ALL OPTIONS============
    apply              Builds or changes infrastructure
    console            Interactive console for Terraform interpolations
    destroy            Destroy Terraform-managed infrastructure
    env                Workspace management
    fmt                Rewrites config files to canonical format
    get                Download and install modules for the configuration
    graph              Create a visual graph of Terraform resources
    import             Import existing infrastructure into Terraform
    init               Initialize a Terraform working directory
    login              Obtain and save credentials for a remote host
    logout             Remove locally-stored credentials for a remote host
    output             Read an output from a state file
    plan               Generate and show an execution plan
    providers          Prints a tree of the providers used in the configuration
    refresh            Update local state file against real resources
    show               Inspect Terraform state or plan
    taint              Manually mark a resource for recreation
    untaint            Manually unmark a resource as tainted
    validate           Validates the Terraform files
    version            Prints the Terraform version
    workspace          Workspace management

All other commands:
    0.12upgrade        Rewrites pre-0.12 module source code for v0.12
    0.13upgrade        Rewrites pre-0.13 module source code for v0.13
    debug              Debug output management (experimental)
    force-unlock       Manually unlock the terraform state
    push               Obsolete command for Terraform Enterprise legacy (v1)
    state              Advanced state management

============LOOPS===========
variable primary_subnets {
  type        = list(string)
  default     = ["web", "app", "db", "mgmt"]
  description = "subnet names of the primary"
}

resource "aws_subnet" "subnets" {
    vpc_id      = aws_vpc.ntier.id
    count       = length(var.primary_subnets)
    cidr_block  = cidrsubnet(var.primary_network_cidr, 8, count.index)
    tags        = {
        Name    = var.primary_subnets[count.index]
    }
} 	}

