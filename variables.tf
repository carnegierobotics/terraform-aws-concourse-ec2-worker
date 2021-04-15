variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = string
  description = "Application or solution name (e.g. `app`)"
  default     = "concourse"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "vpc_id" {
  description = "The VPC id where to deploy the worker instances"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids where to deploy the worker instances"
}

variable "instance_type" {
  description = "EC2 instance type for the worker instances"
  type        = string
  default     = "t3.medium"
}

variable "ssh_key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Boolean flag to enable / disable public IPs for network interfaces"
  type        = bool
  default     = false
}

variable "additional_security_group_ids" {
  type        = list(string)
  description = "Additional security group ids to attach to the worker instances"
  default     = []
}

variable "root_disk_volume_type" {
  description = "Volume type of the worker instances root disk"
  default     = "gp2"
  type        = string
}

variable "root_disk_volume_size" {
  description = "Size of the worker instances root disk"
  default     = "10"
  type        = string
}

variable "work_disk_ephemeral" {
  description = "Whether to use ephemeral volumes as Concourse worker storage. You must use an [`instance_type` that supports this](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html#InstanceStoreDeviceNames)"
  default     = false
  type        = string
}

variable "work_disk_device_name" {
  description = "Device name of the external EBS volume to use as Concourse worker storage"
  default     = "/dev/sdf"
  type        = string
}

variable "work_disk_internal_device_name" {
  description = "Device name of the internal volume as identified by the Linux kernel, which can differ from `work_disk_device_name` depending on used AMI. Make sure this is set according the `instance_type`, eg. `/dev/xvdf` when using an older AMI"
  default     = "/dev/nvme1n1"
  type        = string
}

variable "work_disk_volume_type" {
  description = "Volume type of the external EBS volume to use as Concourse worker storage"
  default     = "gp2"
  type        = string
}

variable "work_disk_volume_size" {
  description = "Size of the external EBS volume to use as Concourse worker storage"
  default     = "100"
  type        = string
}

variable "concourse_tsa_hostname" {
  description = "Hostname where Concourse will be available (NLB)."
  type        = string
}

variable "worker_tsa_port" {
  description = "TSA port that the worker can use to connect to the web"
  default     = 2222
  type        = number
}

variable "concourse_worker_min_count" {
  description = "Min number of Concourse worker instances"
  default     = 1
  type        = number
}

variable "concourse_worker_max_count" {
  description = "Min number of Concourse worker instances"
  default     = 1
  type        = number
}

variable "concourse_version" {
  description = "Concourse CI version to use. Defaults to the latest tested version"
  default     = "5.8.0"
  type        = string
}

variable "concourse_worker_dns_servers" {
  description = "DNS server list"
  default     = ["8.8.8.8", "8.8.4.4"]
  type        = list(string)
}

variable "keys_bucket_id" {
  description = "The S3 bucket id which contains the SSH keys to connect to the TSA"
  type        = string
}

variable "keys_bucket_arn" {
  description = "The S3 bucket ARN which contains the SSH keys to connect to the TSA"
  type        = string
}

variable "concourse_tags" {
  description = "List of tags to add to the worker to use for assigning jobs and tasks"
  type        = list(string)
  default     = []
}

variable "cross_account_worker_role_arn" {
  description = "IAM role ARN to assume to access the Concourse keys bucket in another AWS account"
  default     = null
  type        = string
}

variable "cpu_credits" {
  description = "The credit option for CPU usage. Can be `standard` or `unlimited`"
  default     = "standard"
  type        = string
}
