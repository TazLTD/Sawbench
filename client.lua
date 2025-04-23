local QBCore = exports['qb-core']:GetCoreObject()
local spawnedBenches = {}

-- Simple debug helper
local function dbg(msg, ...)
    if Config.Debug then
        print(('[^2sawbench^7] ' .. msg):format(...))
    end
end

-- Spawn sawbench at vector locations
CreateThread(function()
    for _, loc in pairs(Config.SawbenchSpawns) do
        RequestModel(Config.SawModel)
        while not HasModelLoaded(Config.SawModel) do Wait(100) end

        local obj = CreateObject(Config.SawModel, loc.x, loc.y, loc.z - 1.0, false, true, true)
        SetEntityHeading(obj, loc.w)
        FreezeEntityPosition(obj, true)
        table.insert(spawnedBenches, obj)
    end
end)

-- Register the saw prop for targeting
CreateThread(function()
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
end)

-- Cutting logic
function startCut()
    dbg('startCut() called, checking if player has wood�')
    QBCore.Functions.TriggerCallback('sawbench:canCut', function(hasWood)
        dbg('sawbench:canCut callback => %s', tostring(hasWood))
        if not hasWood then
            QBCore.Functions.Notify('You need 1 wood to cut.', 'error')
            return
        end

        local ped = PlayerPedId()
        local bench = GetClosestObjectOfType(GetEntityCoords(ped), 2.5, GetHashKey(Config.SawModel), false, false, false)
        if bench and DoesEntityExist(bench) then
            local benchCoords = GetEntityCoords(bench)
            local forward = GetEntityForwardVector(bench)
            local offset = 0.5
            local targetPos = benchCoords - forward * offset
            SetEntityCoords(ped, targetPos.x, targetPos.y, targetPos.z)
            SetEntityHeading(ped, GetEntityHeading(bench))
        end

        RequestAnimDict("bzzz_tablesaw_cutting")
        while not HasAnimDictLoaded("bzzz_tablesaw_cutting") do Wait(100) end
        TaskPlayAnim(ped, "bzzz_tablesaw_cutting", "bzzz_tablesaw_cutting", 8.0, -8.0, -1, 50, 0, false, false, false)

        local propModel = `bzzz_prop_tablesaw_wood`
        RequestModel(propModel)
        while not HasModelLoaded(propModel) do Wait(100) end
        local prop = CreateObject(propModel, GetEntityCoords(ped), true, true, false)
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 18905), 0.2, 0.0, 0.2, 0.0, 110.0, 0.0, true, true, false, true, 1, true)

        QBCore.Functions.Progressbar('sawbench_cut', 'Cutting wood into plank...', Config.Progress.duration, false, true,
            { disableMovement = Config.Progress.disableMove, disableCombat = Config.Progress.disableCombat },
            {}, {}, {},
            function()
                TriggerServerEvent('sawbench:doCut')
                ClearPedTasks(ped)
                DeleteEntity(prop)
            end,
            function()
                QBCore.Functions.Notify('Cutting canceled.', 'error')
                ClearPedTasks(ped)
                DeleteEntity(prop)
            end
        )
    end, 'wood')
end
