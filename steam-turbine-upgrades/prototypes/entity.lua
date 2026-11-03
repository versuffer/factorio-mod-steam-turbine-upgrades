local sounds = require("__base__.prototypes.entity.sounds")

-- Vanilla steam turbine at full load (5.82 MW / 60 steam/s => 97 kJ per unit at 500 C):
-- steam-per-MW = 60 / 5.82 ≈ 10.31 steam/s per MW.
local steam_per_mw_per_tick = 10.31 / 60 -- ≈ 0.1718 steam per tick per MW

local mk2_power = settings.startup["steam-turbine-upgrades-mk2-power-mw"].value
local mk3_power = settings.startup["steam-turbine-upgrades-mk3-power-mw"].value
local big_heat_exchanger_power = settings.startup["steam-turbine-upgrades-big-heat-exchanger-power-mw"].value

local working_sound = {
    sound = {
        filename = "__steam-turbine-upgrades__/sounds/steam-turbine.ogg",
        volume = 0.49,
        modifiers = volume_multiplier("main-menu", 0.7),
        speed_smoothing_window_size = 60,
        advanced_volume_control = {attenuation = "exponential"},
        audible_distance_modifier = 0.8
    },
    match_speed_to_activity = true,
    max_sounds_per_prototype = 3,
    fade_in_ticks = 4,
    fade_out_ticks = 20
}

local open_sound = table.deepcopy(data.raw.generator["steam-turbine"].open_sound)
local close_sound = table.deepcopy(data.raw.generator["steam-turbine"].close_sound)

-- MK2 sprites (7:10 art) scaled so the art is 5 tiles wide,
-- on a 5x7 footprint. All shifts are original values multiplied by mk2_factor.

local mk2_scale = 5 / 14
local mk2_factor = mk2_scale / 0.5 -- ratio to the original art setup (scale 0.5)

local mk2_fan = {
    filename = "__steam-turbine-upgrades__/graphics/entity/steam-turbine-mk2/fan.png",
    frame_count = 4,
    line_length = 4,
    width = 656 / 4,
    height = 116,
    run_mode = "backward",
    scale = mk2_scale
}

local mk2_fan_shifts = {
    north = util.by_pixel(0, -56 * mk2_factor),
    south = util.by_pixel(0, -69 * mk2_factor),
    east = util.by_pixel(-11 * mk2_factor, -64 * mk2_factor),
    west = util.by_pixel(12 * mk2_factor, -64 * mk2_factor)
}

local function mk2_fan_layer(direction)
    local layer = table.deepcopy(mk2_fan)
    layer.shift = mk2_fan_shifts[direction]
    return layer
end

local function mk2_animation(body_file, body, body_shift, shadow_file, shadow, shadow_shift, direction)
    return {
        layers = {
            {
                filename = "__steam-turbine-upgrades__/graphics/entity/steam-turbine-mk2/" .. body_file,
                frame_count = 1,
                line_length = 1,
                repeat_count = 4,
                width = body.w,
                height = body.h,
                shift = body_shift,
                scale = mk2_scale
            },
            {
                draw_as_shadow = true,
                filename = "__steam-turbine-upgrades__/graphics/entity/steam-turbine-mk2/" .. shadow_file,
                frame_count = 1,
                line_length = 1,
                repeat_count = 4,
                width = shadow.w,
                height = shadow.h,
                shift = shadow_shift,
                scale = mk2_scale
            },
            mk2_fan_layer(direction)
        }
    }
end

local mk2_body_shift = {0, -0.25 * mk2_factor}        -- original shift {0,-0.25}
local mk2_shadow_shift = {1.5 * mk2_factor, 0.5 * mk2_factor} -- original shift {1.5,0.5}

local mk2_pictures = {
    north = {
        animation = mk2_animation(
            "north.png", {w = 448, h = 672}, mk2_body_shift,
            "north_shadow.png", {w = 640, h = 576}, mk2_shadow_shift,
            "north")
    },
    south = {
        animation = mk2_animation(
            "south.png", {w = 448, h = 672}, mk2_body_shift,
            "south_shadow.png", {w = 640, h = 576}, mk2_shadow_shift,
            "south")
    },
    east = {
        animation = mk2_animation(
            "east.png", {w = 640, h = 480}, mk2_body_shift,
            "east_shadow.png", {w = 832, h = 384}, mk2_shadow_shift,
            "east")
    },
    west = {
        animation = mk2_animation(
            "west.png", {w = 640, h = 480}, mk2_body_shift,
            "west_shadow.png", {w = 832, h = 384}, mk2_shadow_shift,
            "west")
    }
}

-- MK3 sprites at scale 0.7 (art renders 7.2x10.9 tiles on a 7x10 footprint).

local mk3_scale = 0.7
local mk3_factor = mk3_scale / 0.5 -- ratio to the original art setup (scale 0.5)

local mk3_horizontal_animation = {
    layers = {
        {
            filename = "__steam-turbine-upgrades__/graphics/entity/steam-turbine-mk3/advanced-steam-turbine-H.png",
            width = 469,
            height = 270,
            frame_count = 6,
            shift = {0, -0.2 * mk3_factor},
            line_length = 2,
            scale = mk3_scale
        },
        {
            filename = "__steam-turbine-upgrades__/graphics/entity/steam-turbine-mk3/advanced-steam-turbine-sh-H.png",
            width = 514,
            height = 225,
            frame_count = 6,
            shift = {0.575 * mk3_factor, 0.25 * mk3_factor},
            line_length = 3,
            scale = mk3_scale,
            draw_as_shadow = true
        }
    }
}

local mk3_vertical_animation = {
    layers = {
        {
            filename = "__steam-turbine-upgrades__/graphics/entity/steam-turbine-mk3/advanced-steam-turbine-V.png",
            width = 330,
            height = 500,
            frame_count = 6,
            line_length = 6,
            shift = {0.26 * mk3_factor, 0},
            scale = mk3_scale
        },
        {
            filename = "__steam-turbine-upgrades__/graphics/entity/steam-turbine-mk3/advanced-steam-turbine-sh-V.png",
            width = 350,
            height = 425,
            frame_count = 6,
            line_length = 6,
            shift = {0.48 * mk3_factor, 0.36 * mk3_factor},
            scale = mk3_scale,
            draw_as_shadow = true
        }
    }
}

-- Steam buffer: explicit values, vanilla turbine holds 200 steam at 5.82 MW.
local function steam_fluid_box(length, volume)
    return {
        volume = volume,
        pipe_covers = pipecoverspictures(),
        production_type = "input",
        filter = "steam",
        pipe_connections = {
            {flow_direction = "input-output", direction = defines.direction.south, position = {0, length}},
            {flow_direction = "input-output", direction = defines.direction.north, position = {0, -length}}
        }
    }
end

local function mk_turbine(name, power_mw, extra)
    return {
        type = "generator",
        name = name,
        icon = "__steam-turbine-upgrades__/graphics/icons/" .. name .. ".png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 0.3, result = name},
        alert_icon_shift = util.by_pixel(0, -12),
        effectivity = 1,
        burns_fluid = false,
        scale_fluid_usage = true,
        fluid_usage_per_tick = steam_per_mw_per_tick * power_mw,
        max_power_output = tostring(power_mw) .. "MW",
        maximum_temperature = 500, -- steam hotter than 500C counts as 500C: no bonus
        minimum_input_temperature = 100,
        max_health = extra.health,
        corpse = "medium-remnants",
        dying_explosion = "medium-explosion",
        impact_category = "metal-large",
        resistances = {{type = "fire", percent = 70}},
        collision_box = extra.collision_box,
        selection_box = extra.selection_box,
        energy_source = {type = "electric", usage_priority = "secondary-output"},
        fluid_box = extra.fluid_box,
        open_sound = open_sound,
        close_sound = close_sound,
        working_sound = working_sound,
        perceived_performance = {minimum = 0.25, performance_to_activity_rate = 2.0},
        pictures = extra.pictures,
        smoke = {
            {
                name = "turbine-smoke",
                frequency = 10 / 32,
                starting_vertical_speed = 0.08,
                starting_frame_deviation = 60,
                north_position = extra.smoke_positions.north,
                east_position = extra.smoke_positions.east,
                south_position = extra.smoke_positions.south,
                west_position = extra.smoke_positions.west
            }
        }
    }
end

-- Big Heat Exchanger: 6 vanilla heat exchangers in one 5x5 footprint.
-- Vanilla exchanger: 10 MW of heat -> 103.09 steam/s at 500 C, so ours produces
-- proportionally to the configured power (60 MW -> ~618.5 steam/s).
-- Sprites are the SE big heat exchanger art (as used by Linox); heat pipe covers
-- and heat glow come straight from base.

local function bhe_heated_picture(filename, width, height, shift)
    return {
        tint = {1, 1, 1, 1},
        blend_mode = "additive",
        filename = "__steam-turbine-upgrades__/graphics/entity/big-heat-exchanger/" .. filename,
        frame_count = 1,
        line_length = 1,
        width = width,
        height = height,
        shift = shift,
        scale = 0.5
    }
end

local function bhe_pipe_cover(x)
    return {
        filename = "__base__/graphics/entity/heat-exchanger/heatex-endings.png",
        frame_count = 1,
        width = 64,
        height = 64,
        priority = "high",
        scale = 0.5,
        x = x,
        y = 0
    }
end

local function bhe_heated_pipe_cover(x)
    local cover = bhe_pipe_cover(x)
    cover.filename = "__base__/graphics/entity/heat-exchanger/heatex-endings-heated.png"
    cover.tint = {1, 1, 1, 1}
    cover.blend_mode = "additive"
    return cover
end

local function bhe_heat_glow(filename, width, height, shift, tint)
    return {
        filename = "__base__/graphics/entity/heat-exchanger/" .. filename,
        width = width,
        height = height,
        priority = "extra-high",
        shift = shift,
        tint = tint
    }
end

local function bhe_pictures(direction, shadow_width, shadow_height, shadow_shift)
    return {
        structure = {
            layers = {
                {
                    filename = "__steam-turbine-upgrades__/graphics/entity/big-heat-exchanger/" .. direction .. ".png",
                    frame_count = 1,
                    line_length = 1,
                    width = 384,
                    height = 384,
                    shift = {0, -0.5},
                    scale = 0.5
                },
                {
                    draw_as_shadow = true,
                    filename = "__steam-turbine-upgrades__/graphics/entity/big-heat-exchanger/" .. direction .. "_shadow.png",
                    frame_count = 1,
                    line_length = 1,
                    width = shadow_width,
                    height = shadow_height,
                    shift = shadow_shift,
                    scale = 0.5
                }
            }
        }
    }
end

local function big_heat_exchanger(power_mw)
    return {
        type = "boiler",
        name = "big-heat-exchanger",
        icon = "__steam-turbine-upgrades__/graphics/icons/big-heat-exchanger.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 0.3, result = "big-heat-exchanger"},
        max_health = 500,
        corpse = "big-remnants",
        dying_explosion = "medium-explosion",
        impact_category = "metal-large",
        resistances = {
            {type = "fire", percent = 90},
            {type = "explosion", percent = 30},
            {type = "impact", percent = 30}
        },
        collision_box = {{-2.3, -2.3}, {2.3, 2.3}},
        selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
        drawing_box_vertical_extension = 1.5,
        mode = "output-to-separate-pipe",
        target_temperature = 500,
        energy_consumption = tostring(power_mw) .. "MW",
        burning_cooldown = 20,
        fluid_box = {
            volume = 1000,
            filter = "water",
            production_type = "input",
            pipe_covers = pipecoverspictures(),
            pipe_connections = {
                {flow_direction = "input-output", direction = defines.direction.west, position = {-2, 1}},
                {flow_direction = "input-output", direction = defines.direction.east, position = {2, 1}}
            }
        },
        output_fluid_box = {
            volume = 2000,
            filter = "steam",
            production_type = "output",
            pipe_covers = pipecoverspictures(),
            pipe_connections = {
                {flow_direction = "output", direction = defines.direction.north, position = {0, -2}}
            }
        },
        energy_source = {
            type = "heat",
            max_temperature = 1000,
            specific_heat = "1MJ",
            max_transfer = "2GW",
            min_working_temperature = 500,
            minimum_glow_temperature = 350,
            connections = {
                {position = {0, 2}, direction = defines.direction.south}
            },
            pipe_covers = {
                east = bhe_pipe_cover(64),
                north = bhe_pipe_cover(0),
                south = bhe_pipe_cover(128),
                west = bhe_pipe_cover(192)
            },
            heat_pipe_covers = {
                east = bhe_heated_pipe_cover(64),
                north = bhe_heated_pipe_cover(0),
                south = bhe_heated_pipe_cover(128),
                west = bhe_heated_pipe_cover(192)
            },
            heat_picture = {
                east = bhe_heated_picture("east_heated.png", 128, 128, {-2, -0.5}),
                north = bhe_heated_picture("north_heated.png", 64, 160, {0, 1.25}),
                south = bhe_heated_picture("south_heated.png", 64, 64, {0, -2.5}),
                west = bhe_heated_picture("west_heated.png", 128, 128, {2, -0.5})
            },
            heat_glow = {
                east = bhe_heat_glow("heatex-E-heated.png", 60, 62, {-2.1875, -0.875}),
                north = bhe_heat_glow("heatex-N-heated.png", 38, 70, {0, 1.25}, {r = 1, g = 0.85, b = 0.75}),
                south = bhe_heat_glow("heatex-S-heated.png", 28, 40, {0, -2.125}),
                west = bhe_heat_glow("heatex-W-heated.png", 60, 64, {2.125, -0.875})
            }
        },
        circuit_connector = circuit_connector_definitions["boiler"],
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        open_sound = sounds.steam_open,
        close_sound = sounds.steam_close,
        working_sound = {
            sound = {
                filename = "__base__/sound/heat-exchanger.ogg",
                volume = 0.65,
                modifiers = volume_multiplier("main-menu", 0.7),
                audible_distance_modifier = 0.5
            },
            fade_in_ticks = 4,
            fade_out_ticks = 20
        },
        pictures = {
            east = bhe_pictures("east", 512, 352, {1, 0.25}),
            north = bhe_pictures("north", 512, 320, {1.5, 0.5}),
            south = bhe_pictures("south", 512, 256, {1.5, 0.5}),
            west = bhe_pictures("west", 448, 352, {1, 0.25})
        }
    }
end

data.extend({
    mk_turbine("steam-turbine-mk2", mk2_power, {
        health = 600,
        collision_box = {{-2.25, -3.25}, {2.25, 3.25}},
        selection_box = {{-2.5, -3.5}, {2.5, 3.5}},
        fluid_box = steam_fluid_box(3, 2000),
        smoke_positions = {
            -- original smoke spots, scaled from the 7x10 art
            north = {0, -1.25},
            east = {-0.25, -1.43},
            south = {0, -1.54},
            west = {0.31, -1.43}
        },
        pictures = mk2_pictures
    }),
    mk_turbine("steam-turbine-mk3", mk3_power, {
        health = 900,
        collision_box = {{-3.25, -4.75}, {3.25, 4.75}},
        selection_box = {{-3.5, -5}, {3.5, 5}},
        fluid_box = steam_fluid_box(4.5, 6000),
        smoke_positions = {
            -- original north/east positions, scaled; vertical art is shared
            -- by north and south, so the smoke stays top-right in both vertical orientations
            north = {2.8, -3.64},
            east = {3.85, 1.4},
            south = {2.8, -3.64},
            west = {-3.85, 1.4}
        },
        pictures = {
            north = {animation = mk3_vertical_animation},
            south = {animation = mk3_vertical_animation},
            east = {animation = mk3_horizontal_animation},
            west = {animation = mk3_horizontal_animation}
        }
    }),
    big_heat_exchanger(big_heat_exchanger_power)
})
