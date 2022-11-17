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
    local amount = math.random(1, Config.MaxReward)
    if Player.Functions.AddItem(randomItem, amount) then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[randomItem], "add")
        if amount > 1 then
            local msg = ("You found " .. tostring(amount) .. "x " .. randomItem .."!")
            TriggerClientEvent("QBCore:Notify", source, msg, "success")
        end
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
