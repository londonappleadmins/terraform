resource "aws_route53_zone" "main" {
  name = "londonappleadmins.org.uk"
}

resource "aws_route53_record" "laa_root" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  type    = "A"
  name    = "londonappleadmins.org.uk"

  alias {
    name                   = "${aws_cloudfront_distribution.www_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_alias" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  type    = "CNAME"
  name    = "www.londonappleadmins.org.uk"
  ttl     = 300
  records = ["londonappleadmins.org.uk"]
}
