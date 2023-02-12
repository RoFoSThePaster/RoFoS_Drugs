local QBCore = exports['qb-core']:GetCoreObject()
local CurrentCops = 0
-- timer = false


RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('ExcuteDealer', function()
    ExecuteCommand("dealer")
end)


Spawned = false
RegisterNetEvent('rofos_drugs', function()
    if CurrentCops >= Config.minCops then
if Spawned == false then
    Spawned = true
    startSell()
    Citizen.SetTimeout(Config.TimeOut, function()
    Spawned = false
    end)
else
    QBCore.Functions.Notify("Already Doing Something!", "error")
end
    else
     QBCore.Functions.Notify("Not Enough Cops", "error")
    end
end)


RegisterCommand("dealer", function()
	exports['qb-menu']:openMenu({
        {
            header = "🔥 Drug Dealer",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "Sell drugs to junkie?",
            txt = "",
            params = {
                event = "rofos_drugs",
                args = {
                    -- type = "medium"
                }
            }
        },
    })
end)


