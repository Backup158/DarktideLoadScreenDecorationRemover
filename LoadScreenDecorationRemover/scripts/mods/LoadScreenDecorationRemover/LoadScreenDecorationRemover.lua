local mod = get_mod("LoadScreenDecorationRemover")
mod.version = "1.0"
local definition_path = "scripts/ui/views/loading_view/loading_view_definitions"
local UIWidget = require("scripts/managers/ui/ui_widget")
local LoadingView = require("scripts/ui/views/loading_view/loading_view")

-- #################################################################################
--                              Hooker Removal
-- #################################################################################
mod.on_all_mods_loaded = function()
    mod:info("LoadScreenDecorationRemover v" .. mod.version .. " loaded uwu nya :3")

    -- #################################################################################
    -- Divider Removal
    --  The little ---V--- thing between the next prompt and hints
    --  Definitions are stored in:       scripts/ui/views/loading_view/loading_view_definitions.lua
    --      Definitions are called and edited by init, which I hooked
    --      Replacing the texture with a blank path makes it default to a rectangle that gets colored in
    --      Making that color have 0 alpha makes it invisible
    -- #################################################################################
    if mod:get("toggle_divider") then  
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
    end
    -- #################################################################################
    -- Prompt Removal
    --  Replaces the [SPACE] Next prompt with an empty string
    --  Don't need to localize something that I'll just replace later, so the input key and text and commented out
    -- #################################################################################
    if mod:get("toggle_prompt") then
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
    end
end

-- #################################################################################
-- Spinning Skull Removal
-- ###########################
-- Welcome to the graveyard
--  Here you can see my descent into madness
--  This is turning out really annoying to disable
--  None of the code below this point will load into the game
-- ###########################
--  "content/ui/materials/loading/loading_icon"
--      Color:
--          The order is Color(A, R, G, B)
--          When using names, it's Color.<name>(A, bool)
--          Someone made a list with the names https://jsbin.com/zidudotofo/edit?output     
--      Loading Screen Skull:
--          https://discord.com/channels/1048312349867646996/1079236027690012773/1105846568671772783
--          gui.bitmap edits only affect the FIRST frame of the animation
--          this first frame is drawn on top of the others
--              why doesn't it get destroyed? the spinning circle persisted while the skull spun
--          so making a small black box gets hidden on top of the skull
--          the top left corner is the basis for position       
-- #################################################################################
--[[
mod:hook_require("scripts/managers/ui/ui_manager", function(UIManager)
    
    mod:hook_safe(UIManager, "init", function(self)
        --self._ui_loading_icon_renderer = self:create_renderer("ui_loading_icon_renderer")
        self._ui_loading_icon_renderer = nil
    end)
    
    mod:hook_safe(UIManager, "render_black_background", function(self)
        --local gui = self._ui_loading_icon_renderer.gui
        local gui = nil

	    Gui.rect(gui, Vector3.zero(), Vector3(RESOLUTION_LOOKUP.width, RESOLUTION_LOOKUP.height, 0), Color(255, 0, 0, 0))
    end)
    mod:hook_safe(UIManager, "render_loading_icon", function(self)
        --local gui = self._ui_loading_icon_renderer.gui
        local gui = nil

	    self._loading_reason:render(gui, false)
    end)
    mod:hook_safe(UIManager, "render_loading_info", function(self)
        --local gui = self._ui_loading_icon_renderer.gui
        local gui = nil
        local wait_reason, wait_time, text_opacity = self._loading_state_data:current_wait_info()

        self._loading_reason:render(gui, wait_reason, wait_time, text_opacity)
    end)
    
end)
]]
--[[
-- seems to just not do anything
mod:hook_require("scripts/ui/constant_elements/elements/loading/constant_element_loading", function(LoadingIcon)
    local LOADING_ICON = {
        -- loading_icon = true,
        loading_icon = false,
    }
end)
]]
--[[
mod:hook_require("scripts/ui/loading_icon", function(LoadingIcon)
    mod:hook_safe(LoadingIcon, "render", function(gui)
        local resolution_width, resolution_height, resolution_scale = get_resolution()
        local icon_width = 256 * resolution_scale
        local icon_height = 256 * resolution_scale
        --local icon_width = 0
        --local icon_height = 0
        local x_offset = -25 * resolution_scale
        local y_offset = -25 * resolution_scale
        local position = Vector3(x_offset + (resolution_width - icon_width), y_offset + (resolution_height - icon_height), 1000)
        local icon_size = Vector2(icon_width, icon_height)

        --Gui.bitmap(gui, "content/ui/materials/loading/loading_icon", position, icon_size, Color(255, 255, 255, 255))
        --Gui.bitmap(gui, "", position, icon_size, Color(255, 255, 255, 255)) -- !!!!!!! creates a colored box

        --Gui.bitmap(gui, "content/ui/materials/loading/loading_icon", position, Vector2(1, 1), Color(255, 255, 255, 255)) -- trying to shrink it. defaults to icon
        --Gui.bitmap(gui, "", position, Vector2(1, 1), Color(255, 255, 255, 255)) -- trying to shrink it. defaults to icon

        --Gui.bitmap(gui, "content/ui/materials/loading/loading_icon", Vector3(999, 999, 999), icon_size, Color(255, 255, 255, 255)) -- trying to yeet it. defaults to icon
        --Gui.bitmap(gui, "", Vector3(9999, 9999, 999), icon_size, Color(50, 255, 255, 255)) -- trying to yeet it. defaults to icon

        --Gui.bitmap(gui, "", position, icon_size, Color(0, 0, 0, 0)) -- defaults to the actual icon
        Gui.bitmap(gui, "", position, Vector2(1, 1), Color(255, 0, 0, 0)) -- trying to shrink box to one pixel. defaults to icon
        --Gui.bitmap(gui, "", position, Vector2(1, 1), Color(255, 255, 255, 255)) -- trying to shrink box to one pixel. defaults to icon
    end)

end)

-- AFFECTS LOAD SCREENS ONLY
mod:hook_require("scripts/ui/loading_reason", function(LoadingReason)
    mod:hook_safe(LoadingReason, "_render_icon", function(self, gui, anchor_x, anchor_y, resolution_scale)
        --return        -- syntax error
        -- changing scalars for width/offset/position just sets things to default
        local icon_width = 256 * resolution_scale
        local icon_height = 256 * resolution_scale
        --local icon_width = 1 * resolution_scale
        --local icon_height = 1 * resolution_scale
        local offset_x = 0
        --local offset_x = 50
        local offset_y = -25 * resolution_scale
        local position = Vector3(anchor_x + offset_x - icon_width, anchor_y + offset_y - icon_height, 999)
        --local position = Vector3(anchor_x + offset_x - icon_width, anchor_y + offset_y - icon_height, 0) -- trying to send it to the back of the bus. FAIL
        --local position = Vector3(0, 0, 999)
        local icon_size = Vector2(icon_width, icon_height)
        --local icon_size = Vector2(1, 1)

        --Gui.bitmap(gui, "content/ui/materials/loading/loading_icon", position, icon_size, Color(255, 255, 255, 255))
        --Gui.bitmap(gui, "content/ui/materials/loading/loading_small", position, icon_size, Color(255, 255, 255, 255)) -- Trying to replace it with the spinning circle. this just puts a circle around the load icon??
        --Gui.bitmap(gui, "", position, icon_size, Color(255, 255, 255, 255)) -- !!!!!!! creates a colored box (white)
        --Gui.bitmap(gui, "", position, icon_size, Color(255, 0, 0, 0)) -- makes black box
        --Gui.bitmap(gui, "", position, Vector2(50, 50), Color(255, 255, 0, 0)) -- makes small red box. does not hide the animation, but does make a small red box (top left corner is the reference point for pos)
    
        --Gui.bitmap(gui, "", position, Vector2(0, 0), Color(255, 0, 0, 0)) -- fail
        Gui.bitmap(gui, "", position, Vector2(1, 1), Color(255, 0, 0, 0)) -- fail
        --Gui.bitmap(gui, "", position, icon_size, Color(255, 0, 0, 0)) -- changing icon_size in the var. fail
        
    end)
end)
mod:hook_require("scripts/ui/ui_startup_screen", function(UIStartupScreen)
    mod:hook_safe(UIStartupScreen, "render", function(gui)
        local resolution_width, resolution_height, resolution_scale = get_resolution()
        local icon_width = 256 * resolution_scale
        local icon_height = 256 * resolution_scale
        --local icon_width = 0
        --local icon_height = 0
        local x_offset = -25 * resolution_scale
        local y_offset = -25 * resolution_scale
        local position = Vector3(x_offset + (resolution_width - icon_width), y_offset + (resolution_height - icon_height), 1000)
        local icon_size = Vector2(icon_width, icon_height)

        --Gui.bitmap(gui, "content/ui/materials/loading/loading_icon", position, icon_size)
        Gui.bitmap(gui, "", position, icon_size)
        --Gui.rect(gui, Vector3.zero(), Vector3(resolution_width, resolution_height, 0), Color(255, 0, 0, 0))
        Gui.rect(gui, Vector3.zero(), Vector3(resolution_width, resolution_height, 0), Color(0, 0, 0, 0))
    end)

end)
]]
--[[
-- not a hookable function
mod:hook_require("scripts/ui/constant_elements/elements/loading/constant_element_loading", function(VIEW_SETTINGS)
    mod:hook_safe(VIEW_SETTINGS, "validation_func", function()
        if Managers.ui:view_active("lobby_view") then
            return false
        end

        if Managers.mechanism:mechanism_state() == "adventure_selected" then
            --return true, LOADING_ICON
            return true, false
        end

        if Managers.mechanism:mechanism_state() == "client_wait_for_server" then
            --return true, LOADING_ICON
            return true, false
        end

        if Managers.mechanism:mechanism_state() == "client_exit_gameplay" then
            --return true, LOADING_ICON
            return true, false
        end

        if Managers.mechanism:mechanism_state() == false then
            local host_type = Managers.connection:host_type()

            if host_type == HOST_TYPES.mission_server then
                --return true, LOADING_ICON
                return true, false
            end
        end

        if Managers.state and Managers.state.extension then
            local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")
            local intro_played = cinematic_scene_system:intro_played()
            local waiting_for_intro_cinematics = not intro_played

            if waiting_for_intro_cinematics then
                --return true, LOADING_ICON
                return true, false
            end
        end
    end)

end)
]]