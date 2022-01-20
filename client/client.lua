local searched = {3423423424}
local canSearch = true
local dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}
local searchTime = 14000
local idle = 0
local dumpPos
local nearDumpster = false
local maxDistance = 2.5
local listening = false
local dumpster
local currentCoords = nil
local realDumpster

local QBCore = exports['qb-core']:GetCoreObject()

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    local dist = 0
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local playerCoords, awayFromGarbage = GetEntityCoords(PlayerPedId()), true
        if not nearDumpster then
            for i = 1, #dumpsters do
                local distance
                dumpster = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, dumpsters[i], false, false, false)
                if dumpster ~= 0 then
                    realDumpster = dumpster 
                end
                dumpPos = GetEntityCoords(dumpster)
                local distance = #(pos - dumpPos)
                if distance < maxDistance then
                    currentCoords = dumpPos
                end
                if distance < maxDistance then
                    awayFromGarbage = false
                    nearDumpster = true
                end
            end
        end
        if currentCoords ~= nil and #(currentCoords - playerCoords) > maxDistance then
            nearDumpster = false
            listening = false
        end
        if awayFromGarbage then
            Citizen.Wait(1000)
        end
    end
end)


RegisterNetEvent("qb-dumpster:client:dumpsterdive", function()
    listening = true
    currentlySearching = false
    notifiedOfFailure = false
    Citizen.CreateThread(function()
        while listening do
            local dumpsterFound = false
            Citizen.Wait(10)
            for i = 1, #searched do
                if searched[i] == realDumpster then
                    dumpsterFound = true
                end
                if i == #searched and dumpsterFound and not notifiedOfFailure then
                    QBCore.Functions.Notify('This dumpster is empty', 'error')
                    notifiedOfFailure = true
                    Citizen.Wait(1000)
                elseif i == #searched and not dumpsterFound and not currentlySearching then
                    currentlySearching = true
                    QBCore.Functions.Progressbar("dumpsters", "Searching Dumpster", 1000, false, false, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = false,
                    }, {
                        animDict = "amb@prop_human_bum_bin@base",
                        anim = "base",
                        flags = 49,
                    }, {}, {}, function()
                        TriggerServerEvent("qb-dumpster:server:giveDumpsterReward")
                        notifiedOfFailure = true
                        TriggerServerEvent('qb-dumpster:server:startDumpsterTimer', dumpster)
                        table.insert(searched, realDumpster)
                    end, function()
                        QBCore.Functions.Notify('You cancelled the search', 'error')
                    end)
                end
            end
        end
    end)
end)