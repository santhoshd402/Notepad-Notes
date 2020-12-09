PACKER:-
* Packer is a tool for creating machine images for multiple platforms
UseCase:
* Continuous Delivery: For every release a machine image is created using packer which will be used by terraform to create virtual machines
* Packer is used in Demo Environmets as it consists of machine images
Template:
* Templates are JSON files that configure the various components of Packer in order to create one or more machine images.
* Templates are portable, static, and readable and writable by both humans and computers.
* This has the added benefit of being able to not only create and modify templates by hand, but also write scripts to dynamically create or modify templates.

Template_Syntax:
{
    "variables":
    {
        "Key": "Value"
    },
    "builders":
    [
        {
            "Key": "Value"
        }
    ],
    "provisioners":
    [
        {
		"Key": "Value"
        }
    ],
    "Post-Processors":
    [
        {
		"Key": "Value"
        }
    ]
}

** packer build TemplateName
Ex: packer build sample.json

Variables:
* Input variables serve as parameters for a Packer build, allowing aspects of the build to be customized without altering the build's own source code.
* When you declare variables in the build of your configuration, you can set their values using CLI options and environment variables.

Builders
* Builders are responsible for creating machines and generating images from them for various platforms. For example,
  there are separate builders for EC2, VMware, VirtualBox, etc. Packer comes with many builders by default,
  and can also be extended to add new builders

Provisioners:
* Provisioners use builtin and third-party software to install and configure the machine image after booting.
* Provisioners prepare the system for use, so common use cases for provisioners include:
    * installing packages
    * patching the kernel
    * creating users
    * downloading application code

Post-Processors:
* Post-processors run after the image is built by the builder and provisioned by the provisioner(s).
  Post-processors are optional, and they can be used to upload artifacts, re-package, or more

Packer-Options:
* packer -help

Build:
* The packer build command takes a template and runs all the builds within it in order to generate a set of artifacts.
  The various builds specified within a template are executed in parallel,
  unless otherwise specified. And the artifacts that are created will be outputted at the end of the build.
  -debug - Disables parallelization and enables debug mode. Debug mode flags the builders that they should output debugging information.
  -except=foo,bar,baz - Run all the builds and post-processors except those with the given comma-separated names
  -force - Forces a builder to run when artifacts from a previous build prevent a build from running
  -only=foo,bar,baz - Only run the builds with the given comma-separated names.
  -timestamp-ui - Enable prefixing of each ui output with an RFC3339 timestamp
  -parallel-builds=N - Limit the number of builds to run in parallel, 0 means no limit (defaults to 0).
  -var - Set a variable in your packer template. This option can be used multiple times. This is useful for setting version numbers for your build.
  -var-file - Set template variables from a file.
Console:
* The packer console command allows you to experiment with Packer variable interpolations. You may access variables
  in the Packer config you called the console with, or provide variables when you call console using the -var or -var-file command line options.
Fix:
* The packer fix command takes a template and finds backwards incompatible parts of it and brings it up to date so it can be used with the
  latest version of Packer. After you update to a new Packer release, you should run the fix command to make sure your templates work with the new release.
Inspect:
* The packer inspect command takes a template and outputs the various components a template defines.
* command will tell you things like what variables a template accepts, the builders it defines, the provisioners it defines and the order they'll run& more.
Validate:
* Packer command is used to validate the syntax and configuration of a template


Functions_in_Packer:
* packer providing lot of functions
  file functions like abspath, file, fileexists
  timedate fn like formatdate(conv), timeadd(addtime), timestmap(currtime)
  Ex:
  "ami_name": "packer {{timestamp}}"