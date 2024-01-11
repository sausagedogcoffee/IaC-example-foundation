tags = {
  "Platform"               = "Azure Foundations"
  "PlatformOwner"          = ""
  "DataClassification"     = "Confidential"
  "SecurityClassification" = "High"
  "Criticality"            = "Gold"
  "CostCentre"             = ""
}

#The subscription alias here is used to identity it in terraform, as using the name would cause terraform to lose track of it if the name changed.
platform_subscriptions = [
  {
    #Shared services is for all production based shared azure resources. Prod is used here in case a subscription seperation is required between the dev/nonprod application enviornments in the future.
    subscription_name     = "sharedservices-prod-01",
    alias                 = "sharedservicesprod01"
    management_group_name = "mg-sharedservices", #Is convered to the mg id in the main.tf
    tags                  = {}
  },
  #connectivity stores the hub vnet, firewalls, dns, etc. 
  {
    subscription_name     = "connectivity-01",
    alias                 = "connectivity01"
    management_group_name = "mg-connectivity",
    tags = {
      "Criticality" = "Platinum"
    }
  },


  # Identity is not used at this current time.
  # {
  #   subscription_name = "identity-prod-01",
  #   #alias                 = "Identity"
  #   management_group_name = "mg-identity",
  #   tags                  = []
  # }
  
  # Management subscription is used to store logging and other management based services. 
  {
    subscription_name     = "management-01",
    alias                 = "management01"
    management_group_name = "mg-management",
    tags = {
    }
  },
]

# These are the resource groups created in the two subscriptions. Sepeated here due to the use of seperate providers.
resource_groups = {
  shared-services = [
    {
      name = "networkWatcherRG"
      tags = {
        "Criticality" = "Silver"
      }
    },
    {
      name = "rg-sharedservices-identity-ae-01"
      tags = {
        "Criticality" = "Gold"
      }
    },
    {
      name = "rg-sharedservices-network-ae-01"
      tags = {
        "Criticality" = "Gold"
      }

    },
  ]
  connectivity = [
    {
      name = "rg-network-vnet-ae-01"
      tags = {
        "Criticality" = "Platinum"
      }
    },
    {
      name = "networkWatcherRG"
      tags = {
        "Criticality" = "Silver"
      }
    },
    {
      name = "rg-network-private-dns-zones-ae-01"
      tags = {
        "Criticality" = "Platinum"
      }
    },
    {
      name = "rg-network-public-dns-zones-ae-01"
      tags = {
        "Criticality" = "Platinum"
      }
    },
    {
      name = "rg-network-firewall-ae-01"
      tags = {
        "Criticality" = "Platinum"
      }
    },
    {
      name     = "rg-network-firewall-as-01"
      location = "australiasoutheast"
      tags = {
        "Criticality" = "Platinum"
      }
    }
  ]  
}


resource_provider_registrations = [
  "Microsoft.Network",
  "Microsoft.Compute",
  "Microsoft.Security",
  "Microsoft.SecurityInsights"
]
