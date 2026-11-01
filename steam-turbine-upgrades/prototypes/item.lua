data.extend({
    {
        type = "item",
        name = "steam-turbine-mk2",
        icon = "__steam-turbine-upgrades__/graphics/icons/steam-turbine-mk2.png",
        icon_size = 64,
        subgroup = "energy",
        order = "f[nuclear-energy]-e[steam-turbine-mk2]",
        stack_size = 5,
        place_result = "steam-turbine-mk2",
        weight = 200000 -- 200 kg: a full stack (5 x 200 kg) meets the 1 t rocket lift limit
    },
    {
        type = "item",
        name = "steam-turbine-mk3",
        icon = "__steam-turbine-upgrades__/graphics/icons/steam-turbine-mk3.png",
        icon_size = 64,
        subgroup = "energy",
        order = "f[nuclear-energy]-f[steam-turbine-mk3]",
        stack_size = 1,
        place_result = "steam-turbine-mk3",
        weight = 1000000 -- 1 t: one unit per rocket (rocket lift 1 t), like the satellite
    }
})
