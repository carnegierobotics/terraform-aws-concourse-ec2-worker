module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
  attributes = var.attributes
  delimiter  = var.delimiter
}

resource "aws_security_group" "default" {
  name        = module.default_label.id
  description = "Security group for the Concourse worker instances"
  vpc_id      = var.vpc_id
  tags        = module.default_label.tags
}

resource "aws_security_group_rule" "garden" {
  type              = "ingress"
  security_group_id = aws_security_group.default.id
  from_port         = 7777
  to_port           = 7777
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "baggage_claim" {
  type              = "ingress"
  security_group_id = aws_security_group.default.id
  from_port         = 7788
  to_port           = 7788
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "reaper" {
  type              = "ingress"
  security_group_id = aws_security_group.default.id
  from_port         = 7799
  to_port           = 7799
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_tcp" {
  type              = "egress"
  security_group_id = aws_security_group.default.id
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_udp" {
  type              = "egress"
  security_group_id = aws_security_group.default.id
  from_port         = 0
  to_port           = 65535
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}

/*
resource "aws_security_group_rule" "ntp" {
  type              = "egress"
  security_group_id = aws_security_group.default.id
  from_port         = 123
  to_port           = 123
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http" {
  type              = "egress"
  security_group_id = aws_security_group.default.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_out" {
  security_group_id = aws_security_group.default.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh_out" {
  security_group_id = aws_security_group.default.id
  type              = "egress"
  from_port         = 2222
  to_port           = 2222
  protocol          = "tcp"

  # TODO: can this be restricted to the TSA security group?
  cidr_blocks = ["0.0.0.0/0"]
}
*/

# Get the latest ubuntu ami
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


module "autoscale_group" {
  source     = "git::https://github.com/cloudposse/terraform-aws-ec2-autoscale-group.git?ref=tags/0.2.1"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
  attributes = concat(var.attributes, ["asg"])
  delimiter  = var.delimiter

  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_ids                  = var.subnet_ids
  key_name                    = var.ssh_key_name
  min_size                    = var.concourse_worker_min_count
  max_size                    = var.concourse_worker_max_count
  associate_public_ip_address = var.associate_public_ip_address
  security_group_ids          = concat([aws_security_group.default.id], var.additional_security_group_ids)
  iam_instance_profile_name   = aws_iam_instance_profile.default.id
  user_data_base64            = data.template_cloudinit_config.concourse_bootstrap.rendered

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = true
  cpu_utilization_high_threshold_percent = 90
  cpu_utilization_low_threshold_percent  = 20

  credit_specification = {
    cpu_credits = var.cpu_credits
  }

  block_device_mappings = [
    {
      device_name  = "/dev/sda1"
      no_device    = null
      virtual_name = null
      ebs = {
        volume_type           = var.root_disk_volume_type,
        volume_size           = var.root_disk_volume_size,
        delete_on_termination = true
        encrypted             = null
        iops                  = null
        kms_key_id            = null
        snapshot_id           = null
      }
    },
    {
      device_name  = var.work_disk_device_name
      no_device    = null
      virtual_name = null
      ebs = {
        volume_type           = var.work_disk_volume_type,
        volume_size           = var.work_disk_volume_size,
        delete_on_termination = true
        encrypted             = null
        iops                  = null
        kms_key_id            = null
        snapshot_id           = null
      }
    }
  ]
}

data "template_file" "concourse_systemd" {
  template = file("${path.module}/concourse_systemd.tpl")

  vars = {
    concourse_tsa_hostname = "${var.concourse_tsa_hostname}:${var.worker_tsa_port}"
    tags                   = join(" ", formatlist("--tag=%s", var.concourse_tags))
  }
}

data "template_file" "concourse_bootstrap" {
  template = file("${path.module}/bootstrap_concourse.sh.tpl")

  vars = {
    region                        = var.region
    concourse_version             = var.concourse_version
    keys_bucket_id                = var.keys_bucket_id
    cross_account_worker_role_arn = coalesce(var.cross_account_worker_role_arn, 0)
  }
}

data "template_file" "check_attachment" {
  template = file("${path.module}/check_attachment.sh.tpl")

  vars = {
    work_disk_device_name = var.work_disk_device_name
  }
}

data "template_cloudinit_config" "concourse_bootstrap" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "package_update: true"
  }

  part {
    content_type = "text/cloud-config"
    content      = "package_upgrade: true"
  }

  part {
    content_type = "text/cloud-config"

    content = <<EOF
packages:
  - awscli
  - jq
EOF

  }

  # Wait for the EBS volume to become ready
  # And format and mount the drive
  part {
    content_type = "text/x-shellscript"
    content      = var.work_disk_ephemeral ? "" : data.template_file.check_attachment.rendered
  }

  # Format external volume as btrfs
  part {
    content_type = "text/cloud-config"

    content = <<EOF
fs_setup:
  - label: concourseworkdir
    filesystem: 'btrfs'
    device: '${var.work_disk_internal_device_name}'
EOF

  }

  # Mount external volume
  part {
    content_type = "text/cloud-config"

    content = <<EOF
mounts:
  - [ ${var.work_disk_internal_device_name}, /opt/concourse, btrfs, "defaults", "0", "2" ]
EOF

  }

  # Create concourse_worker systemd service file
  part {
    content_type = "text/cloud-config"

    content = <<EOF
write_files:
- encoding: b64
  content: ${base64encode(data.template_file.concourse_systemd.rendered)}
  owner: root:root
  path: /etc/systemd/system/concourse_worker.service
  permissions: '0755'
EOF

  }

  # Bootstrap concourse
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.concourse_bootstrap.rendered
  }
}
