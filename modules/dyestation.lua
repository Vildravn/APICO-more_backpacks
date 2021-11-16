function define_dye_station()
    api_define_menu_object(DEF_OBJ_DYE_STATION, "sprites/items/item_dye_station.png", "sprites/gui/menu_dye_station.png", {
        define = "dye_station_define",
        draw = "dye_station_draw",
        tick = "dye_station_tick",
        change = "dye_station_change"
    })

    recipe = {
        { item = "paintbrush", amount = 1 },
        { item = "barrel", amount = 1 },
        { item = "planks1", amount = 10}
    }
    api_define_recipe("painting", MOD_NAME .. "_dye_station", recipe, 1)
end

function dye_station_define(menu_id)
    api_dp(menu_id, "working", false)
    api_dp(menu_id, "p_start", 0)
    api_dp(menu_id, "p_end", 1)

    api_define_gui(menu_id, "progress_bar", 49, 31, "dye_station_progress_tooltip", "sprites/gui/gui_dye_station_arrow.png")
    api_dp(menu_id, "progress_bar_sprite", api_get_sprite(MOD_NAME .. "_progress_bar"))

    fields = {"p_start", "p_end"}
    fields = api_sp(menu_id, "_fields", fields)

    api_slot_set_modded(api_get_slot(menu_id, 3)["id"], true)
end

function dye_station_draw(menu_id)
    cam = api_get_cam()

    prog_gui = api_get_inst(api_gp(menu_id, "progress_bar"))
    prog_spr = api_gp(menu_id, "progress_bar_sprite")

    prog_gx = prog_gui["x"] - cam["x"]
    prog_gy = prog_gui["y"] - cam["y"]
    progress = (api_gp(menu_id, "p_start") / api_gp(menu_id, "p_end") * 47)
    api_draw_sprite_part(prog_spr, 2, 0, 0, progress, 10, prog_gx, prog_gy)
    api_draw_sprite(prog_spr, 1, prog_gx, prog_gy)

    if api_get_highlighted("ui") == prog_gui["id"] then
        api_draw_sprite(prog_spr, 0, prog_gx, prog_gy)
    end
end

function dye_station_progress_tooltip(menu_id)
    progress = math.floor((api_gp(menu_id, "p_start") / api_gp(menu_id, "p_end")) * 100)
    percent = tostring(progress) .. "%"
    return {{"Progress", "FONT_WHITE"}, {percent, "FONT_BGREY"}}
end

function dye_station_tick(menu_id)
    if api_gp(menu_id, "working") and api_get_slot(menu_id, 3)["item"] == "" then
        api_sp(menu_id, "p_start", api_gp(menu_id, "p_start") + 0.1)

        if api_gp(menu_id, "p_start") >= api_gp(menu_id, "p_end") then
            api_sp(menu_id, "p_start", 0)

            dye_slot = api_get_slot(menu_id, 2)
            input_dye = dye_slot["item"]

            if input_dye ~= "" then
                api_slot_decr(api_get_slot(menu_id, 1)["id"])
                api_slot_decr(dye_slot["id"])

                out_item = ""
                if input_dye == "dye1" then
                    out_item = MOD_NAME .. "_backpack_red"
                elseif input_dye == "dye2" then
                    out_item = MOD_NAME .. "_backpack_blue"
                elseif input_dye == "dye3" then
                    out_item = MOD_NAME .. "_backpack_yellow"
                elseif input_dye == "dye4" then
                    out_item = MOD_NAME .. "_backpack_green"
                elseif input_dye == "dye5" then
                    out_item = MOD_NAME .. "_backpack_orange"
                elseif input_dye == "dye6" then
                    out_item = MOD_NAME .. "_backpack_violet"
                elseif input_dye == "dye7" then
                    out_item = MOD_NAME .. "_backpack_grey"
                end

                output_slot = api_get_slot(menu_id, 3)
                if output_slot["item"] == "" then
                    api_slot_set(output_slot["id"], out_item, 1)
                end
            end
        end

        if api_get_slot(menu_id, 1)["item"] == "" or api_get_slot(menu_id, 2)["item"] == "" then
            api_sp(menu_id, "working", false)
            api_sp(menu_id, "p_start", 0)
        end
    end
end

function dye_station_change(menu_id)
    if api_get_slot(menu_id, 1)["item"] ~= "" and api_get_slot(menu_id, 2)["item"] ~= "" then
        api_sp(menu_id, "working", true)
    else
        api_sp(menu_id, "working", false)
        api_sp(menu_id, "p_start", 0)
    end
end