Config = {}

-- Debug mode
Config.Debug = false

-- Recipes
Config.Recipes = {
    wood = { output = 'plank', amount = 1 },
}

-- Sawbench model and target
Config.SawModel = 'bzzz_prop_tablesaw_a'
Config.Target = {
    icon     = 'fas fa-cut',
    label    = 'Use Cutter',
    distance = 2.5,
}

-- Progress bar
Config.Progress = {
    duration      = 5000,
    disableMove   = true,
    disableCombat = true,
}

-- Sawbench spawn locations
Config.SawbenchSpawns = {
    vector4(-414.45, 1187.79, 325.55, 299.32),
    vector4(-412.56, 1193.17, 325.64, 345.27),
    vector4(-411.86, 1199.25, 325.64, 347.35),
    vector4(-412.32, 1206.34, 325.64, 4.26)
}
