resource "aws_iam_role" "eksClusterRole" {
  name = format("%s-%s-%s-%s-%s","eksCluster",lookup(var.tags, "product"),lookup(var.tags, "env"),"role", lookup(var.tags, "random"))

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge(
   {
     "Name": format("%s-%s-%s-%s-%s","eksCluster",lookup(var.tags, "product"),lookup(var.tags, "env"),"role", lookup(var.tags, "random"))
   },
   var.tags
  )
}

resource "aws_iam_instance_profile" "eksProfile" {
  name = format("%s-%s-%s-%s-%s","eksCluster",lookup(var.tags, "product"),lookup(var.tags, "env"),"eksProfile", lookup(var.tags, "random"))
  role = aws_iam_role.eksClusterRole.name
}

resource "aws_iam_role_policy_attachment" "eksClusterPolicy" {
  role       = aws_iam_role.eksClusterRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eksServicePolicy" {
  role       = aws_iam_role.eksClusterRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}