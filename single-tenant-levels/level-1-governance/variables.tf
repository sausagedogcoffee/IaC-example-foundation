/***************************************************

The below variables need to be stripped out and populated via ADO once we have the pipelines configured

**************************************************/

variable "launchpad_subscription_id" {
  description = "(Required) We need an existing, active subscription to establish a provider. This subscription doesn't need any resources, and the SPN will inherit permissions to it due to having EA Owner priveleges. This will be removed from source control and supplied via KeyVault -> ADO Linked Variable Group."
  default     = ""
}

variable "tenant_id" {
  description = "(Required) The destination tenant where we want to operate. This will be removed from source control and supplied via KeyVault -> ADO Linked Variable Group."
  default     = ""
}

variable "client_id" {
  description = "(Required) The ApplicationId / ClientId (not ObjectId) of the SPN with EA Owner & subscription creation priveleges. This will be removed from source control and supplied via KeyVault -> ADO Linked Variable Group."
  default     = ""
}

variable "client_secret" {
  description = "(Required) The Secret value associated with the aforementioned SPN. This will be removed from source control and supplied via KeyVault -> ADO Linked Variable Group."
  default     = ""
}

variable "billing_account_name" {
  default = "" # Injected by pipeline
}

variable "enrollment_account_name" {
  default = "" # Inject by pipeline
}

/***************************************************

The above variables need to be stripped out and populated via ADO once we have the pipelines configured

**************************************************/

variable "platform_subscriptions" {
  default = []
}

variable "subscription_workload" {
  default = "Production" # Production | DevTest
}

variable "primary_location" {
  default = "australiaeast"
}

# variable "resource_groups" {
#   # type    = map(any)
#   default = {}
# }

variable "resource_provider_registrations" {
  type    = list(string)
  default = []
}

variable "resource_groups" {
  type = map(list(object({
    name     = string
    tags     = optional(map(string), {})
    location = optional(string, "australiaeast")
  })))
  default = {
    sharedservices = [
      {
        name = "networkWatcherRG"        
      }
    ]
  }
}
variable "tags" {
  description = "(Optional) Set of base tags that will be associated with each supported resource."
  default     = {}
}
