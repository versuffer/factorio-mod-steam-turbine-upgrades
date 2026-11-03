local mk2_power_setting = {
    type = "int-setting",
    name = "steam-turbine-upgrades-mk2-power-mw",
    setting_type = "startup",
    minimum_value = 10,
    maximum_value = 100,
    default_value = 60
}

local mk3_power_setting = {
    type = "int-setting",
    name = "steam-turbine-upgrades-mk3-power-mw",
    setting_type = "startup",
    minimum_value = 16,
    maximum_value = 300,
    default_value = 180
}

local big_heat_exchanger_power_setting = {
    type = "int-setting",
    name = "steam-turbine-upgrades-big-heat-exchanger-power-mw",
    setting_type = "startup",
    minimum_value = 16,
    maximum_value = 100,
    default_value = 60
}

data.extend({mk2_power_setting, mk3_power_setting, big_heat_exchanger_power_setting})
