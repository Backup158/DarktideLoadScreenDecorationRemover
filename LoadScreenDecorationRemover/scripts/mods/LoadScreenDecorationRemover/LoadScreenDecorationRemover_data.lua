local mod = get_mod("LoadScreenDecorationRemover")

local filledWidgets = {}
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
    filledWidgets[#filledWidgets + 1] = {
        setting_id = name,
        type = "group",
        sub_widgets = P{},
    }
end

-- Adds a widget for each one in the list of names
add_group_widget("toggleable_during_game")
add_widget_to_group("toggle_hint", filledWidgets.toggleable_during_game, true)
add_widget_to_group("toggle_prompt", filledWidgets.toggleable_during_game, true)

add_group_widget("requires_restart")
add_widget_to_group("toggle_divider", filledWidgets.requires_restart, true)
add_widget_to_group("toggle_skull", filledWidgets.requires_restart, false)

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = filledWidgets,
    },
}
