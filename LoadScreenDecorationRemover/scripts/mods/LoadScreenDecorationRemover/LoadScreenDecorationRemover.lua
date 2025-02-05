local mod = get_mod("LoadScreenDecorationRemover")
mod.version = "1.0"

--disableDivider = true
--disablePrompt = true

mod.on_all_mods_loaded = function()
    mod:info("LoadScreenDecorationRemover v" .. mod.version .. " loaded uwu nya :3")
end

--mod.on_setting_changed = function()
--    disableDivider = mod:get(toggle_divider)
--    disablePrompt = mod:get(toggle_prompt)
--end


-- #################################################################################
--                              Hooker Removal
-- #################################################################################
local definition_path = "scripts/ui/views/loading_view/loading_view_definitions"
local UIWidget = require("scripts/managers/ui/ui_widget")
mod:hook_require("scripts/ui/views/loading_view/loading_view", function(LoadingView)
    -- #################################################################################
    -- Divider Removal
    --  The little ---V--- thing between the next prompt and hints
    --  Definitions are stored in:       scripts/ui/views/loading_view/loading_view_definitions.lua
    --      Definitions are called by init, which I hooked
    --      Replacing the texture with a blank path makes it default to a rectangle that gets colored in
    --      Making that color have 0 opacity makes it invisible
    -- #################################################################################
    mod:hook_safe(LoadingView, "init", function(self, settings, context)
        self._entry_duration = nil
	    self._text_cycle_duration = nil
	    self._update_hint_text = nil

	    local background, background_package = self:select_background()
	    local definitions = require(definition_path)

	    definitions.widget_definitions.title_divider_bottom = UIWidget.create_definition({
            {
                pass_type = "texture",
                --value = "content/ui/materials/dividers/skull_rendered_center_02",
                value = "",
                style = {
                    -- color = Color.white(255, true),
                    color = Color.white(0, true),
                },
            },
        }, "title_divider_bottom"),
        

	    LoadingView.super.init(self, definitions, settings, context, background_package)

	    self._can_exit = context and context.can_exit
	    self._pass_draw = false
	    self._no_cursor = true
    end)

    -- #################################################################################
    -- Prompt Removal
    --  Replaces the [SPACE] Next prompt with an empty string
    --  Don't need to localize something that I'll just replace later, so the input key and text and commented out
    -- #################################################################################
    mod:hook_safe(LoadingView, "_update_input_display", function(self)
        --local text = "loc_next"
        local widgets_by_name = self._widgets_by_name
        local text_widget = widgets_by_name.hint_input_description
        --local localized_text = self:_localize(text)
        local service_type = "View"
        local alias_name = "next_hint"
        local color_tint_text = true
        --local input_key = InputUtils.input_text_for_current_input_device(service_type, alias_name, color_tint_text)

        -- text_widget.content.text = input_key .. " " .. localized_text    -- Original text
        text_widget.content.text = ""
    end)
    
end)
