# octopus-terraform-libraryset-module
easy librarysets in terraform

## Usage

```terraform
module "variable_set_name" {
    source == "git:https://github.com/eternalapprentice2000/octopus-terraform-libraryset-module.git?ref=<latest_version>"

    name = "Library Set Name"
    description = "Description"

    templates = [
        ## regular variable
        {
            name = "Template.Variable.Name"     ## required
            label = "Template Variable Name"    ## optional, default = null
            help_text = "help text info here"   ## optional, default = null
            default_value = "default value"     ## optional, default = null
        },

        ## select box
        {
            name = "Template.Variable.Name"
            label = "Template variable name"
            help_text = "help text info here"
            default_value = "the default value"
            display_settings    = {
                "Octopus.ControlType" = "Select"
                "Octopus.SelectOptions" = join("\n",
                    [
                        "Option1|Option1",
                        "Option2|Option1",
                        ...
                    ]
                )
            }
        },

        ## need to add support for 
        ##  templates with other variable types
        ##  currently this only supports SingleLineText and Select
    ]

    variables = [
        {
            name = "Variable.Name"
            values = [
                ## regular variable
                {
                    id = "random_unique_string_here"    ## required, but this is not the octopus id, just whatever as long as its unique in the group
                    type = "String"                     ## optional, default = "String"
                    value = "some_value_here"           ## required
                    scope = {                           ## optional, default = no scope
                        tenant_tags = [                 ## optional, default = not scoped to tenant_tags
                            "tenant_tag\canonical_name",
                            "tenant_tag\canonical_name_2"
                        ]
                        environments = [                ## optional, default = not scoped to environments
                            "Environments-1"
                        ],
                        channels = [                    ## optional, default = not scoped to channels
                            "Channels-1"
                        ],
                        machines = [                    ## optional, default = not scoped to machines
                            "Machines-1"
                        ],  
                        roles = [                       ## optional, default = not scoped to roles
                            "Roles-1"
                        ],
                        actions = [                     ## optional, default = not scoped to actions
                            "Actions-1"
                        ]

                    }
                },

                ## senstive variable
                {
                    id = "random_unique_string_here_2"
                    type = "Sensitive" ## sensitive variable
                    value = "sensitive value" ## do NOT put the actual value here. use some vault or something.
                },

                ## todo: support other variable types
                ##  currently only String and Sensitive Variable Types are supported
            ]
        }

    ]
}
```
