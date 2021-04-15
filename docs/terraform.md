<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 2.0 |
| local | ~> 1.3 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |
| local | ~> 1.3 |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_security\_group\_ids | Additional security group ids to attach to the worker instances | `list(string)` | `[]` | no |
| associate\_public\_ip\_address | Boolean flag to enable / disable public IPs for network interfaces | `bool` | `false` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| concourse\_tags | List of tags to add to the worker to use for assigning jobs and tasks | `list(string)` | `[]` | no |
| concourse\_tsa\_hostname | Hostname where Concourse will be available (NLB). | `string` | n/a | yes |
| concourse\_version | Concourse CI version to use. Defaults to the latest tested version | `string` | `"5.8.0"` | no |
| concourse\_worker\_dns\_servers | DNS server list | `list(string)` | <pre>[<br>  "8.8.8.8",<br>  "8.8.4.4"<br>]</pre> | no |
| concourse\_worker\_max\_count | Min number of Concourse worker instances | `number` | `1` | no |
| concourse\_worker\_min\_count | Min number of Concourse worker instances | `number` | `1` | no |
| cpu\_credits | The credit option for CPU usage. Can be `standard` or `unlimited` | `string` | `"standard"` | no |
| cross\_account\_worker\_role\_arn | IAM role ARN to assume to access the Concourse keys bucket in another AWS account | `string` | `null` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| instance\_type | EC2 instance type for the worker instances | `string` | `"t3.medium"` | no |
| keys\_bucket\_arn | The S3 bucket ARN which contains the SSH keys to connect to the TSA | `string` | n/a | yes |
| keys\_bucket\_id | The S3 bucket id which contains the SSH keys to connect to the TSA | `string` | n/a | yes |
| name | Application or solution name (e.g. `app`) | `string` | `"concourse"` | no |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | `string` | n/a | yes |
| region | AWS Region for S3 bucket | `string` | n/a | yes |
| root\_disk\_volume\_size | Size of the worker instances root disk | `string` | `"10"` | no |
| root\_disk\_volume\_type | Volume type of the worker instances root disk | `string` | `"gp2"` | no |
| ssh\_key\_name | The key name to use for the instance | `string` | `""` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| subnet\_ids | List of subnet ids where to deploy the worker instances | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |
| vpc\_id | The VPC id where to deploy the worker instances | `string` | n/a | yes |
| work\_disk\_device\_name | Device name of the external EBS volume to use as Concourse worker storage | `string` | `"/dev/sdf"` | no |
| work\_disk\_ephemeral | Whether to use ephemeral volumes as Concourse worker storage. You must use an [`instance_type` that supports this](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html#InstanceStoreDeviceNames) | `string` | `false` | no |
| work\_disk\_internal\_device\_name | Device name of the internal volume as identified by the Linux kernel, which can differ from `work_disk_device_name` depending on used AMI. Make sure this is set according the `instance_type`, eg. `/dev/xvdf` when using an older AMI | `string` | `"/dev/nvme1n1"` | no |
| work\_disk\_volume\_size | Size of the external EBS volume to use as Concourse worker storage | `string` | `"100"` | no |
| work\_disk\_volume\_type | Volume type of the external EBS volume to use as Concourse worker storage | `string` | `"gp2"` | no |
| worker\_tsa\_port | TSA port that the worker can use to connect to the web | `number` | `2222` | no |

## Outputs

| Name | Description |
|------|-------------|
| worker\_iam\_role | Role name of the worker instances |
| worker\_iam\_role\_arn | Role ARN of the worker instances |
| worker\_security\_group\_id | Security group ID used for the worker instances |

<!-- markdownlint-restore -->
