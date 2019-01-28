# resource "aws_acm_certificate" "certificate" {
#   domain_name       = "*.${var.root_domain_name}"
#   validation_method = "DNS"

#   subject_alternative_names = ["${var.root_domain_name}"]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_acm_certificate" "certificate" {
  domain_name       = "*.londonappleadmins.org.uk"
  validation_method = "DNS"

  subject_alternative_names = ["londonappleadmins.org.uk"]

  lifecycle {
    create_before_destroy = true
  }
}

module "dns" {
  source                         = "./dns"
  main_cloudfront_name           = "${aws_cloudfront_distribution.www_distribution.domain_name}"
  main_cloudfront_hosted_zone_id = "${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
}
