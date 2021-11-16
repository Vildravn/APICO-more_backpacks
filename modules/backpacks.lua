function define_backpacks()
    api_define_item(DEF_ITEM_BACKPACK_RED, "sprites/items/item_backpack_red.png")
    api_define_item(DEF_ITEM_BACKPACK_BLUE, "sprites/items/item_backpack_blue.png")
    api_define_item(DEF_ITEM_BACKPACK_YELLOW, "sprites/items/item_backpack_yellow.png")
    api_define_item(DEF_ITEM_BACKPACK_GREEN, "sprites/items/item_backpack_green.png")
    api_define_item(DEF_ITEM_BACKPACK_ORANGE, "sprites/items/item_backpack_orange.png")
    api_define_item(DEF_ITEM_BACKPACK_VIOLET, "sprites/items/item_backpack_violet.png")
    api_define_item(DEF_ITEM_BACKPACK_GREY, "sprites/items/item_backpack_grey.png")
    
    api_define_menu_object(DEF_OBJ_BACKPACK, "sprites/items/item_backpack_red.png", "sprites/gui/menu_backpack.png", {
        define = "backpack_define"
    })
end

function backpack_define(menu_id)
    api_dp(menu_id, "bp_link_id", nil)

    api_set_immortal(api_gp(menu_id, "obj"), true)

    api_sp(menu_id, "_fields", {"bp_link_id"})
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

        mouse = api_get_mouse_inst()["id"]
        stats = {bp_link_id = bp_link_value}
        api_sp(mouse, "item", out_slot["item"])
        api_sp(mouse, "count", 0)
        api_sp(mouse, "stats", stats)
        api_play_sound("click")
    end

    api_slot_clear(out_slot["id"])
end