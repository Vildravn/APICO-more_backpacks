DEF_OBJ_BACKPACK = {
    id = "backpack_obj",
    name = "Backpack Object",
    category = STR_CATEGORY_STORAGE,
    tooltip = "You're not supposed to have this",
    shop_key = true,
    shop_buy = 0,
    shop_sell = 0,
    layout = {
        {7, 17},
        {30, 17},
        {53, 17},
        {76, 17},
        {99, 17},
        {7, 40},
        {30, 40},
        {53, 40},
        {76, 40},
        {99, 40},
        {7, 63},
        {30, 63},
        {53, 63},
        {76, 63},
        {99, 63}
    },
    info = {
        {"1. Storage Slots", "WHITE"},
    },
    buttons = {"Help", "Move", "Sort", "Target", "Close"},
    center = true,
    singular = true,
    invisible = true,
    placeable = true,
    tools = {"mouse1", "hammer1"}
}

DEF_OBJ_DYE_STATION = {
    id = "dye_station",
    name = STR_DYE_STATION,
    category = STR_CATEGORY_CRAFTING,
    tooltip = STR_DYE_STATION_TOOLTIP,
    shop_key = false,
    shop_buy = 0,
    shop_sell = 0,
    layout = {
        {25, 17, "Input", {"backpack1", MOD_NAME .. "_backpack_red", MOD_NAME .. "_backpack_blue", MOD_NAME .. "_backpack_yellow", MOD_NAME .. "_backpack_green", MOD_NAME .. "_backpack_orange", MOD_NAME .. "_backpack_violet", MOD_NAME .. "_backpack_grey"}},
        {54, 17, "Input", {"dye1", "dye2", "dye3", "dye4", "dye5", "dye6", "dye7"}},
        {40, 53, "Output"}},
    info = {
        {"1. Backpack Input", "GREEN"},
        {"2. Dye Input", "YELLOW"},
        {"3. Dyed Backpack Output", "RED"},
        {"4. Variant Buttons", "WHITE"},
    },
    buttons = {"Help", "Move", "Target", "Close"},
    placeable = true,
    tools = {"mouse1", "hammer1"}
}