local QBCore = exports['qb-core']:GetCoreObject()

-- Simple debug helper
local function dbg(msg, ...)
    if Config.Debug then
        print(('[^2sawbench^7] ' .. msg):format(...))
    end
end


Citizen.CreateThread(function()
    for _, location in ipairs(Config.SawbenchLocations) do
        -- Create the sawbench at each specified location
        local propModel = GetHashKey(Config.SawModel)
        RequestModel(propModel)
        while not HasModelLoaded(propModel) do
            Wait(100)
        end
        local sawbench = CreateObject(propModel, location.x, location.y, location.z, false, false, false)
        SetEntityHeading(sawbench, location.w)
        SetEntityAsMissionEntity(sawbench, true, true)
        PlaceObjectOnGroundProperly(sawbench)
    end

    dbg('Sawbenches spawned at designated locations')
end)

Citizen.CreateThread(function()
    Wait(2000)
    exports.ox_target:addModel(Config.SawModel, {{
        name     = 'sawbench_cut',
        icon     = Config.Target.icon,
        label    = Config.Target.label,
        distance = Config.Target.distance,
        onSelect = function(data)
            dbg('ox_target onSelect fired, entity: %s', tostring(data.entity))
            startCut()
        end
    }})
    dbg('addModel called for %s', Config.SawModel)
end)

function startCut()
    dbg('startCut() called, checking if player has wood…')
    QBCore.Functions.TriggerCallback('sawbench:canCut', function(hasWood)
        dbg('sawbench:canCut callback => %s', tostring(hasWood))
        if not hasWood then
            QBCore.Functions.Notify('You need 1 wood to cut.', 'error')
            dbg('Player is missing wood, aborting')
            return
        end

        dbg('Player has wood, starting progress bar')

        local ped = PlayerPedId()

        local bench = GetClosestObjectOfType(GetEntityCoords(ped), 2.5, GetHashKey(Config.SawModel), false, false, false)
if bench and DoesEntityExist(bench) then
    local benchCoords = GetEntityCoords(bench)
    local forward = GetEntityForwardVector(bench)

    local offset = 0.6 
    local targetPos = benchCoords - forward * offset

    SetEntityCoords(ped, targetPos.x, targetPos.y, targetPos.z)
    SetEntityHeading(ped, GetEntityHeading(bench))
end

        -- Load animation
        RequestAnimDict("bzzz_tablesaw_cutting")
        while not HasAnimDictLoaded("bzzz_tablesaw_cutting") do
            Wait(100)
        end

        TaskPlayAnim(ped, "bzzz_tablesaw_cutting", "bzzz_tablesaw_cutting", 8.0, -8.0, -1, 50, 0, false, false, false)

        -- Load and attach prop
        local propModel = `bzzz_prop_tablesaw_wood`
        RequestModel(propModel)
        while not HasModelLoaded(propModel) do
            Wait(100)
        end

        local prop = CreateObject(propModel, GetEntityCoords(ped), true, true, false)
        local boneIndex = GetPedBoneIndex(ped, 18905) -- right hand
        AttachEntityToEntity(prop, ped, boneIndex, 0.2, 0.0, 0.2, 0.0, 110.0, 0.0, true, true, false, true, 1, true)

        -- Start progress bar
        QBCore.Functions.Progressbar(
            'sawbench_cut', 
            'Cutting wood into plank...', 
            Config.Progress.duration,
            false, true,
            { disableMovement = Config.Progress.disableMove, disableCombat = Config.Progress.disableCombat },
            {}, {}, {},
            function()
                dbg('Progress complete, triggering server event')
                TriggerServerEvent('sawbench:doCut')
                ClearPedTasks(ped)
                DeleteEntity(prop)
            end,
            function()
                QBCore.Functions.Notify('Cutting canceled.', 'error')
                dbg('Progress canceled by player')
                ClearPedTasks(ped)
                DeleteEntity(prop)
            end
        )
    end, 'wood')
end

