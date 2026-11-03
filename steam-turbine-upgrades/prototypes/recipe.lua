local is_space_age = mods["space-age"] ~= nil

-- MK3 = MK2 * 3. SA branch adds tungsten-plate (Space Age item); vanilla branch cannot.
local mk2_ingredients = {
    {type = "item", name = "concrete", amount = 100},
    {type = "item", name = "steel-plate", amount = 200},
    {type = "item", name = "pipe", amount = 100},
    {type = "item", name = "iron-gear-wheel", amount = 250},
    {type = "item", name = "copper-plate", amount = 250}
}

local mk3_ingredients = {
    {type = "item", name = "concrete", amount = 300},
    {type = "item", name = "steel-plate", amount = 600},
    {type = "item", name = "pipe", amount = 300},
    {type = "item", name = "iron-gear-wheel", amount = 750},
    {type = "item", name = "copper-plate", amount = 750}
}

-- Big Heat Exchanger = vanilla heat exchanger * 6 (60 steel, 600 copper, 60 pipes).
local bhe_ingredients = {
    {type = "item", name = "steel-plate", amount = 60},
    {type = "item", name = "copper-plate", amount = 600},
    {type = "item", name = "pipe", amount = 60}
}

if is_space_age then
    table.insert(mk2_ingredients, {type = "item", name = "tungsten-plate", amount = 50})
    table.insert(mk3_ingredients, {type = "item", name = "tungsten-plate", amount = 150})
    table.insert(bhe_ingredients, {type = "item", name = "tungsten-plate", amount = 50})
end

data.extend({
    {
        type = "recipe",
        name = "steam-turbine-mk2",
        energy_required = 15,
        enabled = false,
        ingredients = mk2_ingredients,
        results = {{type = "item", name = "steam-turbine-mk2", amount = 1}}
    },
    {
        type = "recipe",
        name = "steam-turbine-mk3",
        energy_required = 45,
        enabled = false,
        ingredients = mk3_ingredients,
        results = {{type = "item", name = "steam-turbine-mk3", amount = 1}}
    },
    {
        type = "recipe",
        name = "big-heat-exchanger",
        energy_required = 18, -- vanilla exchanger takes 3 s
        enabled = false,
        ingredients = bhe_ingredients,
        results = {{type = "item", name = "big-heat-exchanger", amount = 1}}
    }
})
