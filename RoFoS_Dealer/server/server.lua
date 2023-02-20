local QBCore = exports['qb-core']:GetCoreObject()
local bestitemold = 0
local bestitemname

RegisterNetEvent('Checkbestamount', function(drug)
    local Player = QBCore.Functions.GetPlayer(source)
    local itemname = Player.Functions.GetItemByName(drug)
    if itemname.amount > bestitemold then
        bestitemold = itemname.amount
        bestitemname = drug
        -- print('drug amount of '..bestitemname..' is '..bestitemold )
    end
end) 

RegisterNetEvent('rofos:sellDrug', function(amount, CurrentCops, npc)
    src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local itemname = xPlayer.Functions.GetItemByName(bestitemname)
    local dirtyprice = 0
    if itemname.amount >= amount then
    if xPlayer.Functions.RemoveItem(bestitemname, amount) then
        TriggerClientEvent('rofos_dealer_anim', src, npc)
        Wait(3000)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[bestitemname], 'remove', amount)
        TriggerClientEvent('QBCore:Notify', src, "You sold "..bestitemname, "success")
        loop = true
        -- xPlayer.Functions.AddMoney("cash", math.random(Config.drugs[drug].min, Config.drugs[drug].max), "Deal")
        priceamount = math.random(Config.drugs[bestitemname].min, Config.drugs[bestitemname].max)
   if Config.UseBlackAsItem == true then
        for i = 0, amount do
        if CurrentCops >= 3 and CurrentCops <= 7 then
        xPlayer.Functions.AddItem("dirty_money", priceamount+40)
        dirtyprice = dirtyprice + priceamount+40
        elseif CurrentCops > 7 then
        xPlayer.Functions.AddItem("dirty_money", priceamount+80)
        dirtyprice = dirtyprice + priceamount+80
        else
        xPlayer.Functions.AddItem("dirty_money", priceamount)
        dirtyprice = dirtyprice + priceamount
        end    
        end
                    
   else
        for i = 0, amount do
        if CurrentCops >= 3 and CurrentCops <= 7 then
        dirtyprice = dirtyprice + priceamount+40
        elseif CurrentCops > 7 then
        dirtyprice = dirtyprice + priceamount+80
        else
        dirtyprice = dirtyprice + priceamount
        end    
        end
        xPlayer.Functions.AddMoney('blackmoney', dirtyprice)              
   end
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["dirty_money"], 'add', dirtyprice)

    end
    else
    TriggerClientEvent('QBCore:Notify', src, "You Don't Have Enough Product", "error")

    end

    bestitemold = 0
end)


