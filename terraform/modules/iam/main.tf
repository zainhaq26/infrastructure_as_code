# IAM User
resource "aws_iam_user" "main" {
  count = var.create_user ? 1 : 0

  name = var.user_name
  path = var.user_path

  tags = merge(var.tags, {
    Name = var.user_name
  })
}

# IAM User Login Profile
resource "aws_iam_user_login_profile" "main" {
  count = var.create_user && var.create_login_profile ? 1 : 0

  user    = aws_iam_user.main[0].name
  pgp_key = var.pgp_key
}

# IAM User Access Key
resource "aws_iam_access_key" "main" {
  count = var.create_user && var.create_access_key ? 1 : 0

  user   = aws_iam_user.main[0].name
  pgp_key = var.pgp_key
}

# IAM Role
resource "aws_iam_role" "main" {
  count = var.create_role ? 1 : 0

  name                 = var.role_name
  path                 = var.role_path
  assume_role_policy   = var.assume_role_policy
  description          = var.role_description
  max_session_duration = var.max_session_duration

  tags = merge(var.tags, {
    Name = var.role_name
  })
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "main" {
  for_each = var.create_role ? var.managed_policy_arns : {}

  role       = aws_iam_role.main[0].name
  policy_arn = each.value
}

# IAM Inline Policy
resource "aws_iam_role_policy" "main" {
  count = var.create_role && var.inline_policy != "" ? 1 : 0

  name   = "${var.role_name}-inline-policy"
  role   = aws_iam_role.main[0].id
  policy = var.inline_policy
}

# IAM Policy
resource "aws_iam_policy" "main" {
  count = var.create_policy ? 1 : 0

  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = var.policy_document

  tags = merge(var.tags, {
    Name = var.policy_name
  })
}

# IAM Group
resource "aws_iam_group" "main" {
  count = var.create_group ? 1 : 0

  name = var.group_name
  path = var.group_path

  tags = merge(var.tags, {
    Name = var.group_name
  })
}

# IAM Group Membership
resource "aws_iam_group_membership" "main" {
  count = var.create_group && length(var.group_users) > 0 ? 1 : 0

  name  = "${var.group_name}-membership"
  users = var.group_users
  group = aws_iam_group.main[0].name
}

# IAM Group Policy Attachment
resource "aws_iam_group_policy_attachment" "main" {
  for_each = var.create_group ? var.group_managed_policy_arns : {}

  group      = aws_iam_group.main[0].name
  policy_arn = each.value
}

# IAM Group Inline Policy
resource "aws_iam_group_policy" "main" {
  count = var.create_group && var.group_inline_policy != "" ? 1 : 0

  name   = "${var.group_name}-inline-policy"
  group  = aws_iam_group.main[0].id
  policy = var.group_inline_policy
}
