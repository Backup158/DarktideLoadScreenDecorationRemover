local mod = get_mod("LoadScreenDecorationRemover")
mod.version = "1.0"
mod:info("LoadScreenDecorationRemover v" .. mod.version .. " loaded uwu nya :3")

-- #################################################################################
-- Text Removal
-- scripts/ui/views/loading_view/loading_view.lua
--  Replaces the [SPACE] Next prompt with an empty string
--  Don't need to localize something that I'll just replace later, so the input key and text and commented out
-- #################################################################################
mod:hook_require("scripts/ui/views/loading_view/loading_view", function(LoadingView)
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
    
    --[[
    -- Current error: attempted to index local 'self' (a function value)
    mod:hook_safe(LoadingView, "_set_overlay_opacity", function(self, opacity)
        local widget = self._widgets_by_name.overlay

        widget.alpha_multiplier = 1.0
    end)
    ]]
end)


