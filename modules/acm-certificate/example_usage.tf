
# variable "acms_config_list" {
#   type = "list"
#   description = "list of maps that describe acm_san and acm_domain_name for each acm we need to create"

# acms_config_list = [
#   {
#     acm_domain_name                    = "pippo.it"
#     sans_with_same_domain              = "*.pippo.it,paperino.pippo.it"
#     validation_ttl                     = 60
#     allow_validation_record_overwrite  = true
#   },
#   {
#     acm_domain_name                    = "pluto.it"
#     sans_with_same_domain              = "*.pluto.it,paperino.pluto.it"
#     validation_ttl                     = 60
#     allow_validation_record_overwrite  = true
#   },
# ]
#}


# module "acm-certificate" {
#   source                            = "<path of modules>/acm-certificate"
#   count                             = "${length(var.acms_config_list)}"
#   domain_name                       = "${lookup(var.acms_config_list[count.index],"acm_domain_name")}"
#   sans_with_same_domain             = "${split(",",lookup(var.acms_config_list[count.index],"sans_with_same_domain"))}"
#   validation_ttl                    = "${lookup(var.acms_config_list[count.index],"validation_ttl")}"
#   public_hosted_zone_id             = "${lookup(var.acms_config_list[count.index],"public_hosted_zone_id")}"
#   allow_validation_record_overwrite = "${lookup(var.acms_config_list[count.index],"allow_validation_record_overwrite")}"
# }
