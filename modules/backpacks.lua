BACKPACK_COLOR_TABLE = {
    red = {
        flower = "FLOWER1",
        definition = DEF_ITEM_BACKPACK_RED,
        id = "backpack_red",
        name = STR_BACKPACK_RED_NAME,
    },
    blue = {
        flower = "FLOWER2",
        definition = DEF_ITEM_BACKPACK_BLUE,
        id = "backpack_blue",
        name = STR_BACKPACK_BLUE_NAME,
    },
    yellow = {
        flower = "FLOWER3",
        definition = DEF_ITEM_BACKPACK_YELLOW,
        id = "backpack_yellow",
        name = STR_BACKPACK_YELLOW_NAME,
    },
    green = {
        flower = "FLOWER4",
        definition = DEF_ITEM_BACKPACK_GREEN,
        id = "backpack_green",
        name = STR_BACKPACK_GREEN_NAME,
    },
    orange = {
        flower = "FLOWER5",
        definition = DEF_ITEM_BACKPACK_ORANGE,
        id = "backpack_orange",
        name = STR_BACKPACK_ORANGE_NAME,
    },
    violet = {
        flower = "FLOWER6",
        definition = DEF_ITEM_BACKPACK_VIOLET,
        id = "backpack_violet",
        name = STR_BACKPACK_VIOLET_NAME,
    },
    grey = {
        flower = "FLOWER7",
        definition = DEF_ITEM_BACKPACK_GREY,
        id = "backpack_grey",
        name = STR_BACKPACK_GREY_NAME,
    },
}

function define_backpacks()
    for key, value in pairs(BACKPACK_COLOR_TABLE) do
        api_define_item({
            id = value["id"],
            name = value["name"],
            category = STR_CATEGORY_STORAGE,
            tooltip = STR_BACKPACK_TOOLTIP,
            shop_key = true,
            shop_buy = 150,
            shop_sell = 0,
            singular = true
        }, "sprites/items/item_backpack_" .. key .. ".png")
        api_define_sprite(MOD_NAME .. "_backpack_" .. key .. "_open", "sprites/items/item_backpack_open_" .. key .. ".png", 1)
    end

    api_define_sprite("backpack_menu_inside", "sprites/gui/menu_backpack_inside.png", 1)

    api_define_menu_object(DEF_OBJ_BACKPACK, "sprites/items/item_backpack_red.png", "sprites/gui/menu_backpack.png", {
        define = "backpack_define",
        draw = "backpack_draw",
        change = "backpack_change"
    })
end

function backpack_define(menu_id)
    api_dp(menu_id, "bp_link_id", nil)
    api_dp(menu_id, "bp_color", nil)

    api_set_immortal(api_gp(menu_id, "obj"), true)

    fields = {"bp_link_id", "bp_color"}
    api_sp(menu_id, "_fields", fields)
end

function backpack_draw(menu_id)
    cam = api_get_cam()
    menu_inst = api_get_inst(menu_id)
    bp_color = api_gp(menu_id, "bp_color")

    menu_color = BACKPACK_COLOR_TABLE[bp_color]["flower"]

    sx = menu_inst["x"] - cam["x"] + 1
    sy = menu_inst["y"] - cam["y"] + 2

    spr_backpack_menu = api_get_sprite("sp_backpack_menu_inside")
    api_draw_sprite_ext(spr_backpack_menu, 0, sx, sy, 1, 1, 0, menu_color, 1)

    api_draw_slots(menu_id)
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
        in_slot = api_get_slot(menu_id, 1)
        dye_slot = api_get_slot(menu_id, 2)        
        out_slot = api_get_slot(menu_id, 3)

        api_sp(new_menu_id, "bp_link_id", bp_link_value)
        api_sp(new_menu_id, "bp_color", string.gsub(out_slot["item"], MOD_NAME .. "_backpack_", ""))

        mouse = api_get_mouse_inst()["id"]
        stats = {bp_link_id = bp_link_value}
        api_sp(mouse, "item", out_slot["item"])
        api_sp(mouse, "count", 0)
        api_sp(mouse, "stats", stats)
        api_play_sound("click")

        api_slot_decr(in_slot["id"])
        api_slot_decr(dye_slot["id"])
        api_sp(menu_id, "variant_index", 1)
    end

    api_slot_clear(out_slot["id"])
end