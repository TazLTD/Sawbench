Config = {}

-- Debugging (set to true to enable debug prints)
Config.Debug = false

-- Sawbench spawn locations (change these values easily)
Config.SawbenchLocations = {
    vector4(-414.45, 1187.79, 325.55, 299.32),
    vector4(-412.56, 1193.17, 325.64, 345.27),
    vector4(-411.86, 1199.25, 325.64, 347.35),
    vector4(-412.32, 1206.34, 325.64, 4.26)
}

-- Sawbench model and target settings
Config.SawModel = 'bzzz_prop_tablesaw_a'  -- Use the actual model you're targeting
Config.Target = {
    icon     = 'fas fa-cut',
    label    = 'Use Cutter',
    distance = 2.5,
}

-- Progress bar settings (duration in ms)
Config.Progress = {
    duration    = 5000,  -- 5 seconds
    disableMove = true,
    disableCombat = true,
}