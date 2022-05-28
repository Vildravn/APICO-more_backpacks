DYE_TABLE = {
    dye1 = {
        menu_color = "FLOWER1",
        variants = {"backpack_red"}
    },
    dye2 = {
        menu_color = "FLOWER2",
        variants = {"backpack_blue"}
    },
    dye3 = {
        menu_color = "FLOWER3",
        variants = {"backpack_yellow"}
    },
    dye4 = {
        menu_color = "FLOWER4",
        variants = {"backpack_green"}
    },
    dye5 = {
        menu_color = "FLOWER5",
        variants = {"backpack_orange"}
    },
    dye6 = {
        menu_color = "FLOWER6",
        variants = {"backpack_violet"}
    },
    dye7 = {
        menu_color = "FLOWER7",
        variants = {"backpack_grey"}
    },
}

function define_dye_station()
    api_define_sprite("dye_station_color", "sprites/items/item_dye_station_colors.png", 1)

    api_define_menu_object(DEF_OBJ_DYE_STATION, "sprites/items/item_dye_station.png", "sprites/gui/menu_dye_station.png", {
        define = "dye_station_define",
        draw = "dye_station_draw",
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

    if (DYE_TABLE[dye_item] ~= nil) then
        color = DYE_TABLE[dye_item]["menu_color"]
        alpha = 1
    end

    api_draw_sprite_ext(spr_dye_station_color, 0, obj_inst["x"], obj_inst["y"], 1, 1, 0, color, alpha)
end

function dye_station_define(menu_id)
    api_dp(menu_id, "variant_index", 1)
    --api_define_button(menu_id, "variant_back", 24, 56, "", "variant_back_click", "sprites/gui/button_back.png")
    --api_define_button(menu_id, "variant_forward", 62, 56, "", "variant_forward_click", "sprites/gui/button_forward.png")
    --api_define_button(menu_id, "variant_back_dis", 24, 56, "", "", "sprites/gui/button_back_dis.png")
    --api_define_button(menu_id, "variant_forward_dis", 62, 56, "", "", "sprites/gui/button_forward_dis.png")

    api_slot_set_modded(api_get_slot(menu_id, 3)["id"], true)
end

function dye_station_draw(menu_id)
    cam = api_get_cam()
    menu_inst = api_get_inst(menu_id)
    backpack_slot = api_get_slot(menu_id, 1)
    output_slot = api_get_slot(menu_id, 3)

    --[[if output_slot["item"] == "" then
        api_draw_button(api_gp(menu_id, "variant_back_dis"), false)
        api_draw_button(api_gp(menu_id, "variant_forward_dis"), false)
    else
        api_draw_button(api_gp(menu_id, "variant_back"), false)
        api_draw_button(api_gp(menu_id, "variant_forward"), false)
    end]]--

    rx = menu_inst["x"] - cam["x"]
    ry = menu_inst["y"] - cam["y"]

    if backpack_slot["item"] ~= "" then
        api_draw_text(rx + 5, ry + 82, "Dyeing this backpack will destroy its contents!", true, "FONT_RED", 130)
    end
end

function variant_back_click(menu_id, arg2)
    api_sp(menu_id, "variant_index", api_gp(menu_id, "variant_index") - 1)
    dye_station_change(menu_id)
end

function variant_forward_click(menu_id)
    api_sp(menu_id, "variant_index", api_gp(menu_id, "variant_index") + 1)
    dye_station_change(menu_id)
end

function dye_station_change(menu_id)
    backpack_slot = api_get_slot(menu_id, 1)
    dye_slot = api_get_slot(menu_id, 2)
    output_slot = api_get_slot(menu_id, 3)

    if backpack_slot["item"] ~= "" and dye_slot["item"] ~= "" then
        out_item = ""

        if DYE_TABLE[dye_slot["item"]] ~= nil then
            variants = DYE_TABLE[dye_slot["item"]]["variants"]
            index = api_gp(menu_id, "variant_index")

            if index > #variants then
                index = 1
            elseif index < 1 then
                index = #variants
            end

            api_sp(menu_id, "variant_index", index)

            out_item = MOD_NAME .. "_" .. variants[index]
            api_log("change", out_item)
            api_slot_set(output_slot["id"], out_item, 1)
        end
    elseif output_slot["item"] ~= "" then
        api_slot_clear(output_slot["id"])
        api_slot_decr(dye_slot)
        api_sp(menu_id, "variant_index", 1)
    end
end