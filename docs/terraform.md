## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_security_group_ids | Additional security group ids to attach to the worker instances | list(string) | `<list>` | no |
| associate_public_ip_address | Boolean flag to enable / disable public IPs for network interfaces | bool | `false` | no |
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| concourse_tags | List of tags to add to the worker to use for assigning jobs and tasks | list(string) | `<list>` | no |
| concourse_tsa_hostname | Hostname where Concourse will be available (NLB). | string | - | yes |
| concourse_version | Concourse CI version to use. Defaults to the latest tested version | string | `5.8.0` | no |
| concourse_worker_max_count | Min number of Concourse worker instances | number | `1` | no |
| concourse_worker_min_count | Min number of Concourse worker instances | number | `1` | no |
| cpu_credits | The credit option for CPU usage. Can be `standard` or `unlimited` | string | `standard` | no |
| cross_account_worker_role_arn | IAM role ARN to assume to access the Concourse keys bucket in another AWS account | string | `null` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| instance_type | EC2 instance type for the worker instances | string | `t3.medium` | no |
| keys_bucket_arn | The S3 bucket ARN which contains the SSH keys to connect to the TSA | string | - | yes |
| keys_bucket_id | The S3 bucket id which contains the SSH keys to connect to the TSA | string | - | yes |
| name | Application or solution name (e.g. `app`) | string | `concourse` | no |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| region | AWS Region for S3 bucket | string | - | yes |
| root_disk_volume_size | Size of the worker instances root disk | string | `10` | no |
| root_disk_volume_type | Volume type of the worker instances root disk | string | `gp2` | no |
| ssh_key_name | The key name to use for the instance | string | `` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| subnet_ids | List of subnet ids where to deploy the worker instances | list(string) | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map(string) | `<map>` | no |
| vpc_id | The VPC id where to deploy the worker instances | string | - | yes |
| work_disk_device_name | Device name of the external EBS volume to use as Concourse worker storage | string | `/dev/sdf` | no |
| work_disk_ephemeral | Whether to use ephemeral volumes as Concourse worker storage. You must use an [`instance_type` that supports this](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html#InstanceStoreDeviceNames) | string | `false` | no |
| work_disk_internal_device_name | Device name of the internal volume as identified by the Linux kernel, which can differ from `work_disk_device_name` depending on used AMI. Make sure this is set according the `instance_type`, eg. `/dev/xvdf` when using an older AMI | string | `/dev/nvme1n1` | no |
| work_disk_volume_size | Size of the external EBS volume to use as Concourse worker storage | string | `100` | no |
| work_disk_volume_type | Volume type of the external EBS volume to use as Concourse worker storage | string | `gp2` | no |
| worker_tsa_port | TSA port that the worker can use to connect to the web | number | `2222` | no |

## Outputs

| Name | Description |
|------|-------------|
| worker_iam_role | Role name of the worker instances |
| worker_iam_role_arn | Role ARN of the worker instances |
| worker_security_group_id | Security group ID used for the worker instances |

