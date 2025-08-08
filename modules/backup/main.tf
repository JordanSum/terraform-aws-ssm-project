terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 6.4.0"
      configuration_aliases = [aws.west1, aws.west2, aws.east]
    }
  }
}

#West Region

resource "aws_backup_plan" "ssm_ec2_backup_west" {
  name = "${var.project_name}-backup-plan-west"
  provider = aws.west2

  rule {
    rule_name         = "${var.project_name}-backup-rule-west"
    target_vault_name = aws_backup_vault.ec2_backup_vault_west.name
    schedule          = "cron(0 * * * ? *)" #Runs every hour

    lifecycle {
      delete_after = 14
    }

    # Cross-Region copy to west1 vault
    copy_action {
      destination_vault_arn = aws_backup_vault.ec2_backup_vault_west_copy.arn
      lifecycle {
        delete_after = 30
      }
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}

data "aws_caller_identity" "current_west" {
  provider = aws.west2
}

resource "aws_backup_vault" "ec2_backup_vault_west" {
  name = "ec2_backup_vault_west1"
  provider = aws.west2
}

data "aws_iam_policy_document" "backup_vault_policy_west" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current_west.account_id}:root"]
    }

    actions = [
      "backup:DescribeBackupVault",
      "backup:DeleteBackupVault",
      "backup:PutBackupVaultAccessPolicy",
      "backup:DeleteBackupVaultAccessPolicy",
      "backup:GetBackupVaultAccessPolicy",
      "backup:StartBackupJob",
      "backup:GetBackupVaultNotifications",
      "backup:PutBackupVaultNotifications",
    ]

    resources = [aws_backup_vault.ec2_backup_vault_west.arn]
  }
}

resource "aws_backup_vault_policy" "ec2_backup_vault_west" {
  backup_vault_name = aws_backup_vault.ec2_backup_vault_west.name
  policy            = data.aws_iam_policy_document.backup_vault_policy_west.json
  provider = aws.west2
}

resource "aws_backup_selection" "ec2_backup_selection_west" {
  name          = "${var.project_name}-backup-selection-west"
  iam_role_arn  = var.backup_iam_role_arn
  plan_id = aws_backup_plan.ssm_ec2_backup_west.id
  provider = aws.west2

  resources = [
    "arn:aws:ec2:us-west-2:${data.aws_caller_identity.current_west.account_id}:instance/${var.west_instance_1_id}",
    "arn:aws:ec2:us-west-2:${data.aws_caller_identity.current_west.account_id}:instance/${var.west_instance_2_id}",
  ]
}



#East Region

resource "aws_backup_plan" "ssm_ec2_backup_east" {
  name = "${var.project_name}-backup-plan-east"
  provider = aws.east

  rule {
    rule_name         = "${var.project_name}-backup-rule-east"
    target_vault_name = aws_backup_vault.ec2_backup_vault_east.name
    schedule          = "cron(0 * * * ? *)" #Runs every hour

    lifecycle {
      delete_after = 14
    }

    # Cross-Region copy to west1 vault
    copy_action {
      destination_vault_arn = aws_backup_vault.ec2_backup_vault_west_copy.arn
      lifecycle {
        delete_after = 30
      }
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}

data "aws_caller_identity" "current_east" {
  provider = aws.east
}

resource "aws_backup_vault" "ec2_backup_vault_east" {
  name = "ec2_backup_vault_east"
  provider = aws.east
}

data "aws_iam_policy_document" "backup_vault_policy_east" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current_east.account_id}:root"]
    }

    actions = [
      "backup:DescribeBackupVault",
      "backup:DeleteBackupVault",
      "backup:PutBackupVaultAccessPolicy",
      "backup:DeleteBackupVaultAccessPolicy",
      "backup:GetBackupVaultAccessPolicy",
      "backup:StartBackupJob",
      "backup:GetBackupVaultNotifications",
      "backup:PutBackupVaultNotifications",
    ]

    resources = [aws_backup_vault.ec2_backup_vault_east.arn]
  }
}

resource "aws_backup_vault_policy" "ec2_backup_vault_east" {
  backup_vault_name = aws_backup_vault.ec2_backup_vault_east.name
  policy            = data.aws_iam_policy_document.backup_vault_policy_east.json
  provider = aws.east
}

resource "aws_backup_selection" "ec2_backup_selection_east" {
  name          = "${var.project_name}-backup-selection-east"
  iam_role_arn  = var.backup_iam_role_arn
  plan_id = aws_backup_plan.ssm_ec2_backup_east.id
  provider = aws.east

  resources = [
    "arn:aws:ec2:us-east-2:${data.aws_caller_identity.current_east.account_id}:instance/${var.east_instance_1_id}",
    "arn:aws:ec2:us-east-2:${data.aws_caller_identity.current_east.account_id}:instance/${var.east_instance_2_id}",
  ]
}

#Copy Vault located in West1

resource "aws_backup_vault" "ec2_backup_vault_west_copy" {
  name = "ec2_backup_vault_west_copy"
  provider = aws.west1
}

data "aws_iam_policy_document" "backup_vault_policy_west_copy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current_west.account_id}:root"]
    }

    actions = [
      "backup:DescribeBackupVault",
      "backup:DeleteBackupVault",
      "backup:PutBackupVaultAccessPolicy",
      "backup:DeleteBackupVaultAccessPolicy",
      "backup:GetBackupVaultAccessPolicy",
      "backup:StartBackupJob",
      "backup:GetBackupVaultNotifications",
      "backup:PutBackupVaultNotifications",
    ]

    resources = [aws_backup_vault.ec2_backup_vault_west_copy.arn]
  }
}

resource "aws_backup_vault_policy" "ec2_backup_vault_west_copy" {
  backup_vault_name = aws_backup_vault.ec2_backup_vault_west_copy.name
  policy            = data.aws_iam_policy_document.backup_vault_policy_west_copy.json
  provider          = aws.west1
}



