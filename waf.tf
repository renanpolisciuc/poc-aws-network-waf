resource "aws_wafregional_ipset" "ipset" {
  name = "pocIpSet"

  ip_set_descriptor {
    type  = "IPV4"
    value = "${var.my_ip_for_test}/32"
  }
}

resource "aws_wafregional_rule" "wafrule" {
  depends_on  = [aws_wafregional_ipset.ipset]
  name        = "pocWafRule"
  metric_name = "pocWafRule"

  predicate {
    data_id = aws_wafregional_ipset.ipset.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_wafregional_web_acl_association" "aclassoc" {
  resource_arn = aws_lb.lb.arn
  web_acl_id   = aws_wafregional_web_acl.wafacl.id
}

resource "aws_wafregional_web_acl" "wafacl" {
  name        = "pocWafACL"
  metric_name = "pocWafACL"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = aws_wafregional_rule.wafrule.id
    type     = "REGULAR"
  }
}