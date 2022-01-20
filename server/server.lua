local QBCore = exports['qb-core']:GetCoreObject()

local timer = Config.WaitTime * 60 * math.random(1000, 10000)

RegisterServerEvent('qb-dumpster:server:startDumpsterTimer')
AddEventHandler('qb-dumpster:server:startDumpsterTimer', function(dumpster)
    startTimer(source, dumpster)
end)

RegisterServerEvent('qb-dumpster:server:giveDumpsterReward')
AddEventHandler('qb-dumpster:server:giveDumpsterReward', function()
    local Player = QBCore.Functions.GetPlayer(source) 
    local randomItem = Config.Items[math.random(1, #Config.Items)]
    if Player.Functions.AddItem(randomItem, 1) then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[randomItem], "add")
    else
        TriggerClientEvent("QBCore:Notify", source, "You dont have enough space", "error")
    end
end)

function startTimer(id, object)
    Citizen.CreateThread(function()
        Citizen.Wait(timer)
        TriggerClientEvent('qb-dumpster:server:startDumpsterTimer', id, object)
    end)
end
