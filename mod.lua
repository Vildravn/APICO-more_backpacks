MOD_NAME = "more_backpacks"
MOD_VERSION = "Alpha 0.1"
MOD_AUTHOR = "Vildravn"

function register()
    return {
        name = MOD_NAME,
        hooks = {"click"},
        modules = {"dyestation", "backpacks", "definitions", "strings"}
    }
end

function init()
    define_backpacks()

    define_dye_station()

    return "Success"
end

function click(button, click_type)
    mouse = api_get_mouse_inst()
    highlight_slot = api_get_highlighted("slot")

    if highlight_slot ~= nil and click_type == "PRESSED" then
        if button == "LEFT" and mouse["item"] == "" then
            menu_id = api_gp(highlight_slot, "menu")
            out_slot = api_get_slot(menu_id, 3)
            oid = api_gp(menu_id, "oid")

            if oid == MOD_NAME .. "_dye_station" and highlight_slot == out_slot["id"] and out_slot["item"] ~= "" then
                make_backpack(menu_id)
            end
        end

        if button == "RIGHT" then
            slot_item = api_gp(highlight_slot, "item")
            if string.find(slot_item, MOD_NAME .. "_backpack_") ~= nil then
                item_link_id = api_gp(highlight_slot, "stats")["bp_link_id"]

                backpacks = api_get_menu_objects(nil, MOD_NAME .. "_backpack_obj", nil)
                for i=1,#backpacks do
                    menu_link_id = api_gp(backpacks[i]["menu_id"], "bp_link_id")
                    if menu_link_id == item_link_id then
                        open = api_gp(backpacks[i]["menu_id"], "open")
                        api_toggle_menu(backpacks[i]["menu_id"], not open)
                        break
                    end
                end
            end
        end
    end
end