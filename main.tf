resource "octopusdeploy_library_variable_set" "variable_set" {
    name = var.name
    description = var.description

    dynamic "template" {
        for_each = [
            for k,v in var.templates : {
                name                = v.name,
                id                  = "${lower(replace(replace(var.name, " ", ""),"-", ""))}.template.${lower(v.name)}"
                label               = lookup(v, "label", null)
                default_value       = lookup(v, "default_value", null)
                help_text           = lookup(v, "help_text", null)
                display_settings    = lookup(v, "display_settings", null)
            }
        ]

        content {
            name                = template.value.name
            label               = template.value.label
            default_value       = template.value.default_value
            help_text           = template.value.help_text
            display_settings    = template.value.display_settings
        }
    }
}

locals {
    sorted = flatten([
        for k, v in var.variables : [
            for vv in v.values : {
                key_name = "${v.name}_${vv.uid}",
                value = try(vv.value, null),
                type = try(vv.type, "String"),
                name = v.name,
                scope = try(vv.scope, null) == null ? [] : [vv.scope],
                is_sensitive = try(vv.type, null) == "Sensitive"? true : false
            }
        ]
    ])
}

resource "octopusdeploy_variable" "variables" {
    for_each = {
        for v in local.sorted : v.key_name => {
            value           = v.value,
            type            = v.type,
            name            = v.name,
            scope           = v.scope,
            is_sensitive    = v.is_sensitive
        } 
    }

    owner_id        = octopusdeploy_library_variable_set.variable_set.id
    type            = each.value.type
    name            = each.value.name
    value           = each.value.is_sensitive == true ? null : each.value.value
    sensitive_value = each.value.is_sensitive == true ? each.value.value : null
    is_sensitive    = each.value.is_sensitive

    dynamic "scope" {
        for_each = each.value.scope

        content{
            tenant_tags     = try(scope.value.tenant_tags, [])
            environments    = try(scope.value.environments, [])
            channels        = try(scope.value.channels, [])
            machines        = try(scope.value.machines, [])
            roles           = try(scope.value.roles, [])
            actions         = try(scope.value.actions, [])
        }
    }
}
