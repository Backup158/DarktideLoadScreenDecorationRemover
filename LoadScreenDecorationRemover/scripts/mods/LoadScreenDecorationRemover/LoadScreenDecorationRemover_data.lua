local mod = get_mod("LoadScreenDecorationRemover")

local filledWidgets = {}
local widgetNames = {"toggle_hint", "toggle_divider", "toggle_prompt", "toggle_skull"}
--local widgetNames = {}

-- Appends a toggleable option for a new widget
local function addWidget(name)
    -- Write at (table size) + 1, ie inserting at the tail
    filledWidgets[#filledWidgets + 1] = {
        setting_id = name,
        type = "checkbox",
        default_value = true,
    }
end

-- Adds a widget for each one in the list of names
for _, name in pairs(widgetNames) do
    addWidget(name)
end

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = filledWidgets,
    },
}
