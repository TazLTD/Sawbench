local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {}

QBCore.Functions.CreateCallback('sawbench:canCut', function(src, cb, inputItem)
    local ply = QBCore.Functions.GetPlayer(src)
    if not ply then return cb(false) end
    local itm = ply.Functions.GetItemByName(inputItem)
    cb(itm and itm.amount >= 1 or false)
end)

RegisterServerEvent('sawbench:doCut')
AddEventHandler('sawbench:doCut', function()
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local input = 'wood'
    local r = Config.Recipes[input]

    if not ply or not r then
        if Config.Debug then print('[sawbench] Invalid cut request from', src) end
        return
    end

    local success, _ = exports.ox_inventory:RemoveItem(src, input, 1)
    if not success then
        if Config.Debug then print('[sawbench] Failed to remove wood from', src) end
        return
    end

    success, _ = exports.ox_inventory:AddItem(src, r.output, r.amount)
    if not success then
        if Config.Debug then print('[sawbench] Failed to add plank to', src) end
        exports.ox_inventory:AddItem(src, input, 1)
        return
    end

    if Config.Debug then
        print(('[sawbench] %d: %s ? %s x%d'):format(src, input, r.output, r.amount))
    end
end)
