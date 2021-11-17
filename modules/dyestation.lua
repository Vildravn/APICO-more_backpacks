function define_dye_station()
    api_define_sprite("dye_station_color", "sprites/items/item_dye_station_colors.png", 1)

    api_define_menu_object(DEF_OBJ_DYE_STATION, "sprites/items/item_dye_station.png", "sprites/gui/menu_dye_station.png", {
        define = "dye_station_define",
        draw = "dye_station_draw",
        tick = "dye_station_tick",
        change = "dye_station_change"
    }, "draw_dye_station")

    recipe = {
        { item = "paintbrush", amount = 1 },
        { item = "barrel", amount = 1 },
        { item = "planks1", amount = 10}
    }

    api_define_recipe("painting", MOD_NAME .. "_dye_station", recipe, 1)
end

function draw_dye_station(obj_id)
    obj_inst = api_get_inst(obj_id)
    spr_dye_station = api_get_sprite("sp_more_backpacks_dye_station")
    spr_dye_station_color = api_get_sprite("sp_dye_station_color")

    if api_get_highlighted("obj") == obj_id then
        api_draw_sprite(spr_dye_station, 1, obj_inst["x"], obj_inst["y"])
    else
        api_draw_sprite(spr_dye_station, 0, obj_inst["x"], obj_inst["y"])
    end

    color = nil
    alpha = 0
    dye_item = api_get_slot(obj_inst["menu_id"], 2)["item"]

    if dye_item == "dye1" then
        color = "FLOWER1"
        alpha = 1
    elseif dye_item == "dye2" then
        color = "FLOWER2"
        alpha = 1
    elseif dye_item == "dye3" then
        color = "FLOWER3"
        alpha = 1
    elseif dye_item == "dye4" then
        color = "FLOWER4"
        alpha = 1
    elseif dye_item == "dye5" then
        color = "FLOWER5"
        alpha = 1
    elseif dye_item == "dye6" then
        color = "FLOWER6"
        alpha = 1
    elseif dye_item == "dye7" then
        color = "FLOWER7"
        alpha = 1
    end

    api_draw_sprite_ext(spr_dye_station_color, 0, obj_inst["x"], obj_inst["y"], 1, 1, 0, color, alpha)
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