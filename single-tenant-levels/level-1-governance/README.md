# IaC-example-foundation
Terraform Cloud Adoption Framework IaC 


#Level 1: Core platform governance

The different landing zones represented in different state files at level 1 would typically be:

    The Azure landing zone (management groups, policies) this would include the core ALZ (formerly called enterprise-scale) capabilities with the related custom management group structures and policies configuration. You can either use the out-of-the-box settings for Azure LZ or customize the values for your organization.
    The GitOps services for core platform automation: creating the pipelines, creating the Virtual Network and compute nodes (see below) required for the DevOps self-hosted agents.
    The platform subscription creation for core platform (to create the core enterprise-scale subscriptions like Identify, Management, Connectivity etc.)
    The management subscription services for core platform capabilities such as log management, Azure Monitor capabilities, etc.
    The identity subscription services for core platform such as domain controller virtual machines, Azure Active Directory Domain Services, Azure AD Group mappings etc.