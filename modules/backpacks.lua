spr_backpack_menu = nil

function define_backpacks()
    api_define_item(DEF_ITEM_BACKPACK_RED, "sprites/items/item_backpack_red.png")
    api_define_item(DEF_ITEM_BACKPACK_BLUE, "sprites/items/item_backpack_blue.png")
    api_define_item(DEF_ITEM_BACKPACK_YELLOW, "sprites/items/item_backpack_yellow.png")
    api_define_item(DEF_ITEM_BACKPACK_GREEN, "sprites/items/item_backpack_green.png")
    api_define_item(DEF_ITEM_BACKPACK_ORANGE, "sprites/items/item_backpack_orange.png")
    api_define_item(DEF_ITEM_BACKPACK_VIOLET, "sprites/items/item_backpack_violet.png")
    api_define_item(DEF_ITEM_BACKPACK_GREY, "sprites/items/item_backpack_grey.png")
    
    spr_backpack_menu = api_define_sprite("backpack_menu_inside", "sprites/gui/menu_backpack_inside.png", 1)

    api_define_menu_object(DEF_OBJ_BACKPACK, "sprites/items/item_backpack_red.png", "sprites/gui/menu_backpack.png", {
        define = "backpack_define",
        draw = "backpack_draw",
        change = "backpack_change"
    })
end

function backpack_define(menu_id)
    api_dp(menu_id, "bp_link_id", nil)
    api_dp(menu_id, "bp_item_oid", nil)

    api_set_immortal(api_gp(menu_id, "obj"), true)

    fields = {"bp_link_id", "bp_item_oid"}
    api_sp(menu_id, "_fields", fields)
end

function backpack_draw(menu_id)
    cam = api_get_cam()
    menu_inst = api_get_inst(menu_id)
    backpack_oid = api_gp(menu_id, "bp_item_oid")

    menu_color = nil
    if backpack_oid == MOD_NAME .. "_backpack_red" then
        menu_color = "FLOWER1"
    elseif backpack_oid == MOD_NAME .. "_backpack_blue" then
        menu_color = "FLOWER2"
    elseif backpack_oid == MOD_NAME .. "_backpack_yellow" then
        menu_color = "FLOWER3"
    elseif backpack_oid == MOD_NAME .. "_backpack_green" then
        menu_color = "FLOWER4"
    elseif backpack_oid == MOD_NAME .. "_backpack_orange" then
        menu_color = "FLOWER5"
    elseif backpack_oid == MOD_NAME .. "_backpack_violet" then
        menu_color = "FLOWER6"
    elseif backpack_oid == MOD_NAME .. "_backpack_grey" then
        menu_color = "FLOWER7"
    end

    sx = menu_inst["x"] - cam["x"] + 1
    sy = menu_inst["y"] - cam["y"] + 2
    --api_draw_sprite_ext(spr_backpack_menu, 0, sx, sy, 1, 1, 0, menu_color, 1)
end

function backpack_change(menu_id)
    backpack_slot = api_slot_match(menu_id,{
        "backpack1",
        MOD_NAME .. "_backpack_red",
        MOD_NAME .. "_backpack_blue",
        MOD_NAME .. "_backpack_yellow",
        MOD_NAME .. "_backpack_green",
        MOD_NAME .. "_backpack_orange",
        MOD_NAME .. "_backpack_violet",
        MOD_NAME .. "_backpack_grey",
    }, true)

    if backpack_slot ~= nil then
        mouse = api_get_mouse_inst()["id"]

        api_sp(mouse, "item", backpack_slot["item"])
        api_sp(mouse, "count", 0)
        api_sp(mouse, "stats", backpack_slot["stats"])

        api_slot_clear(backpack_slot["id"])
    end
end

function make_backpack(menu_id)
    api_create_obj(MOD_NAME .. "_backpack_obj", -32, -32)

    new_menu_id = nil
    bp_link_value = nil
    backpacks = api_get_menu_objects(nil, MOD_NAME .. "_backpack_obj", nil)
    for i=1,#backpacks do
        link_id = api_gp(backpacks[i]["menu_id"], "bp_link_id")
        if link_id == nil then
            new_menu_id = backpacks[i]["menu_id"]
            bp_link_value = "backpack" .. #backpacks
            break
        end
    end

    if new_menu_id ~= nil then
        out_slot = api_get_slot(menu_id, 3)

        api_sp(new_menu_id, "bp_link_id", bp_link_value)
        api_sp(new_menu_id, "bp_item_oid", out_slot["item"])

        mouse = api_get_mouse_inst()["id"]
        stats = {bp_link_id = bp_link_value, }
        api_sp(mouse, "item", out_slot["item"])
        api_sp(mouse, "count", 0)
        api_sp(mouse, "stats", stats)
        api_play_sound("click")
    end

    api_slot_clear(out_slot["id"])
end