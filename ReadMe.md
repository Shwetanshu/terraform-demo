Providers : Responsible for understanding API interaction and exposing resources

Resources : 
    resource "azurerm_resource_group" "TestRG"
    =======   ======= =============    ======
    Component  Provider  Type          Name

Provisioners: When a resource is  initially created, provisioner can be executed to initialize that resource

Terraform Execution :   - terraform plan
                        - terraform apply
                        - terraform destroy

Service Principal: An azure Service principal is a security identity used by user-created apps, services and automation tools to access specific Azure resources.

User permission:    Create Azure AD Application Registration -> Create Key -> Assign Application to role 
                    Service like terraform  ->  Login as Application    ->  Execute task (like deploying VM)