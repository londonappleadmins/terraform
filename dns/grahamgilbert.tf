variable "main_zone_host" {
  default = "laa.grahamgilbert.com"
}

variable "main_cloudfront_name" {}

variable "main_cloudfront_hosted_zone_id" {}

resource "aws_route53_record" "grahamgilbert_root" {
  zone_id = "Z2VP0FHJ6U7I35"
  type    = "A"
  name    = "${var.main_zone_host}"

  alias {
    name                   = "${var.main_cloudfront_name}"
    zone_id                = "${var.main_cloudfront_hosted_zone_id}"
    evaluate_target_health = false
  }
}
