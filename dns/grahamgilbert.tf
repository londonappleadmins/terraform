variable "main_zone_host" {
  default = "laa.grahamgilbert.com"
}

variable "www_host" {
  default = "www.laa.grahamgilbert.com"
}

variable "main_cloudfront_name" {}

variable "main_cloudfront_hosted_zone_id" {}

variable "zone_id" {
  default = "Z2VP0FHJ6U7I35"
}

resource "aws_route53_record" "laa_root" {
  zone_id = "${var.zone_id}"
  type    = "A"
  name    = "${var.main_zone_host}"

  alias {
    name                   = "${var.main_cloudfront_name}"
    zone_id                = "${var.main_cloudfront_hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "laa_www" {
  zone_id = "${var.zone_id}"
  type    = "CNAME"
  name    = "${var.www_host}"
  records        = ["${var.main_zone_host}"]
  ttl = 60
}
