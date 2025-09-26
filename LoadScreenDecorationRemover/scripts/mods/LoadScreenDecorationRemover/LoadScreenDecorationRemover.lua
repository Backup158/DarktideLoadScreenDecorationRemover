local mod = get_mod("LoadScreenDecorationRemover")
mod.version = "1.1.0"

-- Requirements for hint/divider/prompt
local definition_path = "scripts/ui/views/loading_view/loading_view_definitions"
local UIWidget = require("scripts/managers/ui/ui_widget")
local LoadingView = require("scripts/ui/views/loading_view/loading_view")
-- For loading reason (shocking!)
local LoadingReason = require("scripts/ui/loading_reason")
-- For spinning skull
local LoadingIcon = require("scripts/ui/loading_icon")

-- #################################################################################
--                              Hooker Removal
-- NOTE: Using conditionals inside a hook causes a syntax error. I think it's because of the 'end' of the if being confused for the 'end)' of the hook arguments
-- Hooks all the releva
-- #################################################################################
local function hook_the_boys()

    -- #################################################################################
    -- Hint Removal
    -- Hints are the loading screen quotes.
    -- #################################################################################
    mod:hook_safe(LoadingView, "_set_hint_text_opacity", function(self, opacity)
        local widget = self._widgets_by_name.hint_text

        --widget.alpha_multiplier = opacity
        widget.alpha_multiplier = 0
    end)
    if not mod:get("toggle_hint") then
        mod:hook_disable(LoadingView, "_set_hint_text_opacity")
    end

    -- #################################################################################
    -- Divider Removal
    -- Dividers are the little ---V--- thing between the next prompt and hints
    --  Definitions are stored in:       scripts/ui/views/loading_view/loading_view_definitions.lua
    --      Definitions are called and edited by init, which I hooked
    --      Replacing the texture with a blank path makes it default to a rectangle that gets colored in
    --      Making that color have 0 alpha makes it invisible
    -- Hook
    --  Hook happens before the main body and may not always happen
    --  vs safe hook, to go back remove the func
    --  chosen to avoid the black background
    -- #################################################################################
    if mod:get("toggle_divider") then
        mod:hook(LoadingView, "init", function(func, self, settings, context)
            --self._entry_duration = nil
            --self._text_cycle_duration = nil
            --self._update_hint_text = nil

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
            }, "title_divider_bottom")
            
            LoadingView.super.init(self, definitions, settings, context, background_package)

            --self._can_exit = context and context.can_exit
            --self._pass_draw = false
            --self._no_cursor = true
        end)
    end
    
    -- #################################################################################
    -- Prompt Removal
    --  Replaces the [SPACE] Next prompt with an empty string
    --  Hook safe 
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
    if not mod:get("toggle_prompt") then
        mod:hook_disable(LoadingView, "_update_input_display")
    end

    -- #################################################################################
    -- Loading Reason Removal
    -- Wanted an alternative implementation from RemoveLoadingStatus but it'll just be easier to make that a soft requirement lol.
    -- Plus gpk already did this specific part, so I'll just send people there
    -- #################################################################################
    --[[ 
    -- userToggledReason not written yet!
    if userToggledReason then
        mod:hook_origin(LoadingReason, "_render_text", function(self, gui, anchor_x, anchor_y, resolution_scale, text, text_opacity)
            return
        end)
    end
    ]]

    -- #################################################################################
    -- Spinning Skull Removal
    -- On the loading screens ONLY
    -- #################################################################################
    if mod:get("toggle_skull") then
        mod:hook_origin(LoadingReason, "_render_icon", function(self, gui, anchor_x, anchor_y, resolution_scale)
            return
        end)
    end
end

-- #################################################################################
--                              Calling Hooks
-- #################################################################################
local function find_which_hook_to_affect(setting_id)
    -- so this table will be made every time you change settings, but i think that's fine vs having it always exist as the mod runs
    local setting_and_hook_pairs = {
        toggle_hint = "_set_hint_text_opacity",
        --toggle_divider = "init", -- only runs on startup so it doesn't matter
        toggle_prompt = "_update_input_display",
        -- hook origin can't be rehooked, so forget this for the skull
    }
    return setting_and_hook_pairs[setting_id]
end

mod.on_all_mods_loaded = function()
    mod:info("LoadScreenDecorationRemover v" .. mod.version .. " loaded uwu nya :3")
    
    hook_the_boys()
end

mod.on_setting_changed = function(setting_id)
    -- cant disable hook_origin, so skip
    if (setting_id == "toggle_skull") or (setting_id == "toggle_divider") then return end

    local setting_changed_to = mod:get(setting_id)
    local hook_to_affect = find_which_hook_to_affect(setting_id)

    -- if setting was enabled and is now disabled (which means show the thing again)
    if not setting_changed_to then
        mod:hook_disable(LoadingView, hook_to_affect)
    else
        mod:hook_enable(LoadingView, hook_to_affect)
    end
end
