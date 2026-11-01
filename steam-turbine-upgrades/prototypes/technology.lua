local is_space_age = mods["space-age"] ~= nil

-- Tech icons are the entity sprites.

local mk2_prerequisites = is_space_age and {"heating-tower"} or {"nuclear-power"}

-- Vanilla branch (no Space Age): 6 packs. SA branch adds metallurgic-science-pack.
local science_packs = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1},
    {"space-science-pack", 1}
}

if is_space_age then
    table.insert(science_packs, {"metallurgic-science-pack", 1})
end

local mk2_unit = {
    count = 500,
    time = 60,
    ingredients = science_packs
}

local mk3_unit = {
    count = 1000,
    time = 60,
    ingredients = science_packs
}

data.extend({
    {
        type = "technology",
        name = "steam-turbine-mk2",
        effects = {
            {type = "unlock-recipe", recipe = "steam-turbine-mk2"}
        },
        icon = "__steam-turbine-upgrades__/graphics/entity/steam-turbine-mk2/tech-icon.png",
        icon_size = 672,
        order = "e-f",
        prerequisites = mk2_prerequisites,
        unit = mk2_unit
    },
    {
        type = "technology",
        name = "steam-turbine-mk3",
        effects = {
            {type = "unlock-recipe", recipe = "steam-turbine-mk3"}
        },
        icon = "__steam-turbine-upgrades__/graphics/entity/steam-turbine-mk3/tech-icon.png",
        icon_size = 500,
        order = "e-g",
        prerequisites = {"steam-turbine-mk2"},
        unit = mk3_unit
    }
})
