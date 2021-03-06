resource "aws_iam_user" "laa_s3_deploy" {
  name = "laa_s3_deploy"
}

data "aws_iam_policy_document" "laa_s3_policy_data" {
  statement {
    sid = "1"

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.www.arn}",
      "${aws_s3_bucket.www.arn}/*",
    ]
  }

  statement {
    actions = [
      "acm:ListCertificates",
      "cloudfront:GetDistribution",
      "cloudfront:GetStreamingDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudfront:ListCloudFrontOriginAccessIdentities",
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
      "elasticloadbalancing:DescribeLoadBalancers",
      "iam:ListServerCertificates",
      "sns:ListSubscriptionsByTopic",
      "sns:ListTopics",
      "waf:GetWebACL",
      "waf:ListWebACLs",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "laa_deploy_policy" {
  name   = "laa_deploy_policy"
  policy = "${data.aws_iam_policy_document.laa_s3_policy_data.json}"
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = "${aws_iam_user.laa_s3_deploy.name}"
  policy_arn = "${aws_iam_policy.laa_deploy_policy.arn}"
}
