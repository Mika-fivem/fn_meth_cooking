Config = {}

Config.job = nil -- set to job name so the points can be seen only by them (set to nil to disable)

Config.ingredient_order = {"antifreeze","acetone","redphosphorus","sudafed"} -- order in which ingredients need to be put in
Config.ingredient_heat_order = {45,65,80,35} -- order of heat that has to be set before putting in ingredient
Config.heat_error_margin = 3 -- +- how big of an error will be tolerated (set to 0 so the heat needs to be spot on)

Config.lang = {
    harvest = "Press ~INPUT_CONTEXT~ to start harvesting %s", -- %s <- item name
    cooking_menu = "Press ~INPUT_CONTEXT~ to open cooking menu",
    cooking_menu_title = "Meth lab",
    heat = "Heat: %d°C", -- %d <- temperature
    add = "Add %dx %s", -- %d, %s <- item count, item name
    select_scount = "How much meth do you want to cook?",
    meth_count = "About to make %d meth",
    blew_up = "Your meth exploded!",
    not_enough_items = "You don't have enough ingredients to make %d meth!", -- %d <- meth count
    cooking_exit_warn = "If you exit the menu now you won't get your ingredients back!",
    used = "USED"
}

Config.point = {
    type = 1,
    size = vector3(1.0,1.0,0.2),
    color = {r = 255, g = 255, b = 255, a = 150}
}

Config.cook_location = vector3(-1847.0,-3145.0,13.0) -- position at which you'll be able to cook the meth

Config.antifreeze = {
    enabled = true, -- point enabled (set to false if you'll get the ingredient some other way)
    pos = vector3(-1847.0,-3140.0,13.0), -- position of the point
    time = 15, -- how many seconds it takes to get item
    count = 1 -- how many items you get per cycle
}

Config.acetone = {
    enabled = true,
    pos = vector3(0.0,0.0,0.0),
    time = 15,
    count = 1
}

Config.redphosphorus = {
    enabled = true,
    pos = vector3(0.0,0.0,0.0), 
    time = 15,
    count = 1
}

Config.sudafed = {
    enabled = true,
    pos = vector3(0.0,0.0,0.0),
    time = 15,
    count = 1
}