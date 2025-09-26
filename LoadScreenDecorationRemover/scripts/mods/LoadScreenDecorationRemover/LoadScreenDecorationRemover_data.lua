local mod = get_mod("LoadScreenDecorationRemover")

local filled_widgets = {}
--local widgetNames = {"toggle_hint", "toggle_divider", "toggle_prompt"}
--local widgetNamesDefaultFalse = {"toggle_skull"}
--local widgetNames = {}

-- Appends a toggleable option for a new widget
local function add_widget_to_group(name, group_location, truth)
    -- Write at (table size) + 1, ie inserting at the tail
    group_location[#group_location + 1] = {
        setting_id = name,
        type = "checkbox",
        default_value = truth,
    }
end
local function add_group_widget(name)
    filled_widgets[#filled_widgets + 1] = {
        setting_id = name,
        type = "group",
        sub_widgets = {},
    }
end

-- Adds a widget for each one in the list of names
add_group_widget("toggleable_during_game")
add_widget_to_group("toggle_hint", filled_widgets[1].sub_widgets, true)
add_widget_to_group("toggle_prompt", filled_widgets[1].sub_widgets, true)

add_group_widget("requires_restart")
add_widget_to_group("toggle_divider", filled_widgets[2].sub_widgets, true)
add_widget_to_group("toggle_skull", filled_widgets[2].sub_widgets, false)

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = filled_widgets,
    },
}
