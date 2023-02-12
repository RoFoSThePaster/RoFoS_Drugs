local QBCore = exports['qb-core']:GetCoreObject()

local CurrentCops = 0

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)


function spawnClient(name, x, y, z, h)

   -- local hash = GetHashKey(name)

    RequestModel(name)

    while not HasModelLoaded(name) do Wait(500) end

    local pnj = CreatePed(6, name, x, y, z, h, true, false)

    return pnj

end

function createBlip(x, y, z)

    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite (blip, 51)
    SetBlipScale  (blip, 1.0)
    SetBlipDisplay(blip, 4)
    SetBlipColour (blip, 1)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Client")
    EndTextCommandSetBlipName(blip)

    return blip

end

-- function DrawText3D(x,y,z, text)
--     local onScreen,_x,_y=World3dToScreen2d(x,y,z)
--     local px,py,pz=table.unpack(GetGameplayCamCoords())
--     SetTextScale(0.45, 0.45)
--     SetTextFont(4)
--     SetTextProportional(1)
--     SetTextColour(255, 0, 0, 215)
--     SetTextEntry("STRING")
--     SetTextCentre(1)
--     AddTextComponentString(text)
--     DrawText(_x,_y)
-- end
local function InProccess(var)
    if var == true then
        index = true
    else
        index = false
    end
end

local function LoadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end
function unloadModel(model) if Config.Debug then print("^5Debug^7: ^2Removing Model^7: '^6"..model.."^7'") end SetModelAsNoLongerNeeded(model) end
function loadAnimDict(dict) if Config.Debug then print("^5Debug^7: ^2Loading Anim Dictionary^7: '^6"..dict.."^7'") end while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end
function unloadAnimDict(dict) if Config.Debug then print("^5Debug^7: ^2Removing Anim Dictionary^7: '^6"..dict.."^7'") end RemoveAnimDict(dict) end
function loadPtfxDict(dict)	if Config.Debug then print("^5Debug^7: ^2Loading Ptfx Dictionary^7: '^6"..dict.."^7'") end while not HasNamedPtfxAssetLoaded(dict) do RequestNamedPtfxAsset(dict) Wait(5) end end
function unloadPtfxDict(dict) if Config.Debug then print("^5Debug^7: ^2Removing Ptfx Dictionary^7: '^6"..dict.."^7'") end RemoveNamedPtfxAsset(dict) end
function loadModel(model)
    local time = 1000
    if not HasModelLoaded(model) then if Config.Debug then print("^5Debug^7: ^2Loading Model^7: '^6"..model.."^7'") end
	while not HasModelLoaded(model) do if time > 0 then time = time - 1 RequestModel(model)
		else time = 1000 print("^5Debug^7: ^3LoadModel^7: ^2Timed out loading model ^7'^6"..model.."^7'") break end
		Wait(10) end
	end
end
function destroyProp(entity)
	SetEntityAsMissionEntity(entity) Wait(5)
	DetachEntity(entity, true, true) Wait(5)
	DeleteEntity(entity)
end

function makeProp(data, freeze, synced)
    loadModel(data.prop)
    local prop = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z, synced or 0, synced or 0, 0)
    SetEntityHeading(prop, data.coords.w)
    FreezeEntityPosition(prop, freeze or 0)
    return prop
end

function lookPedEnt(entity)
	if type(entity) == "vector3" then
		if not IsPedHeadingTowardsPosition(entity, PlayerPedId(), 30.0) then
            TaskTurnPedToFaceCoord(PlayerPedId(), entity, 1500)
            TaskTurnPedToFaceCoord(entity, PlayerPedId(), 1500)
			Wait(1500)
		end
	else
		if DoesEntityExist(entity) then
			if not IsPedHeadingTowardsPosition(entity, GetEntityCoords(PlayerPedId()), 30.0) then
                TaskTurnPedToFaceCoord(PlayerPedId(), GetEntityCoords(entity), 1500)
                TaskTurnPedToFaceCoord(entity, GetEntityCoords(PlayerPedId()), 1500)
				Wait(1500)
			end
		end
	end
end

bag = nil
RegisterNetEvent("rofos_dealer_anim")
AddEventHandler('rofos_dealer_anim', function(npc)
Citizen.CreateThread(function()
    loadAnimDict("mp_common")
    loadAnimDict("amb@prop_human_atm@male@enter")
    if bag == nil then bag = makeProp({prop = `prop_paper_bag_small`, coords = vector4(0,0,0,0)}, 0, 1) end
    AttachEntityToEntity(bag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, -0.0, 0.0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
    --Calculate if you're facing the ped--
    ClearPedTasksImmediately(PlayerPedId())
    -- lookEnt(npc)
    lookPedEnt(npc)
    TaskPlayAnim(npc, "amb@prop_human_atm@male@enter", "enter", 1.0, 1.0, 0.3, 16, 0.2, 0, 0, 0)	--Start animations
    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_b", 1.0, 1.0, 0.3, 16, 0.2, 0, 0, 0)
    Wait(1000)
    AttachEntityToEntity(bag, npc, GetPedBoneIndex(npc, 57005), 0.1, -0.0, 0.0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
    Wait(1000)
    StopAnimTask(npc, "amb@prop_human_atm@male@enter", "enter", 1.0)
    StopAnimTask(PlayerPedId(), "mp_common", "givetake2_b", 1.0)
    unloadAnimDict("mp_common")
    unloadAnimDict("amb@prop_human_atm@male@enter")
    destroyProp(bag) unloadModel(`prop_paper_bag_small`)
    bag = nil
end)
end)
index = false
timer = false

function startSell()
    if index == false then        
    -- if timer == false then
    QBCore.Functions.Notify("Searching for a client!", "success")
    local canSell = true
    npccoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 30.0, 5.0)
	retval, npcz = GetGroundZFor_3dCoord(npccoords.x, npccoords.y, npccoords.z, 0)

    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, true)
    SetTimeout(math.random(Config.minTime, Config.maxTime), function()

    ClearPedTasks(PlayerPedId())

        QBCore.Functions.Notify("A fien is approaching you", "success")
        InProccess(true)
        local pos = GetEntityCoords(PlayerPedId())
        local randomped = math.random(#Config.Peds)
        -- local pnj = spawnClient(Config.Peds[randomped], pos.x+28, pos.y+28, pos.z)
        local pnj = spawnClient(Config.Peds[randomped], npccoords.x, npccoords.y, npcz)
        local pos2 = GetEntityCoords(pnj)
        local blip = createBlip(pos2.x, pos2.y, pos2.z)
        
        TaskGoToEntity(pnj, PlayerPedId(), 60000, 4.0, 2.0, 0, 0)

        CreateThread(function()

            local wait = 1000
            local dst
            amount = math.random(1,4)
            chance = math.random(1,5)
        
        while canSell do 

                pos = GetEntityCoords(PlayerPedId())
                pos2 = GetEntityCoords(pnj)
                dst = #(pos - pos2)

            if dst <= 2 then 
                wait = 0
                if chance == 3 then
                    QBCore.Functions.Notify("Your product is shitty!", "error")
                    -- timer = true
                    RemoveBlip(blip)
                    TaskWanderStandard(pnj)
                    canSell = false
                    InProccess(false)
                    
                else
                    --------
                    -- DrawText3D(pos2.x, pos2.y, pos2.z, "Buying "..amount.." Drugs")
                    QBCore.Functions.DrawText3D(pos2.x, pos2.y, pos2.z, "~g~E~w~ - Buying "..amount.." Drugs")

                    if IsControlJustPressed(0, 51) then 
                        -- timer = true
                        local hasDrugs = false
                        for drug, info in pairs(Config.drugs) do
                            if QBCore.Functions.HasItem(drug) then 
                               -- QBCore.Functions.Notify("You sold "..drug, "success")
                                hasDrugs = true
                                -- TriggerServerEvent('rofos:sellDrug', drug, amount, CurrentCops, pnj)
                                -- RemoveBlip(blip)
                                -- Citizen.Wait(2500)
                                -- TaskWanderStandard(pnj)
                                -- canSell = false
                                -- InProccess(false)
                                TriggerServerEvent("Checkbestamount", drug)
                            end
                        end
                        


                        if not hasDrugs then
                            QBCore.Functions.Notify("You don't have any drugs to sell", "error")
                            RemoveBlip(blip)
                            TaskWanderStandard(pnj)
                            canSell = false
                            InProccess(false)
                        else
                            TriggerServerEvent('rofos:sellDrug', amount, CurrentCops, pnj)
                            RemoveBlip(blip)
                            Citizen.Wait(3000)
                            TaskWanderStandard(pnj)
                            canSell = false
                            InProccess(false)
                        end
                        -- TriggerServerEvent('rofos:sellDrug')
                        -- RemoveBlip(blip)
                        -- TaskWanderStandard(pnj)
                        -- canSell = false

                    end
                end
            else 
            wait = 1000             
            end
            if dst>100 then
            InProccess(false)
            TaskWanderStandard(pnj)
            RemoveBlip(blip)
            canSell = false
            QBCore.Functions.Notify("Too Far From Customer", "error")
            end
        Wait(wait)
            end
        
        end)
        exports["ps-dispatch"]:CustomAlert({
            coords = vector3(pos2.x, pos2.y, pos2.z),
            message = "Criminal Activity",
            dispatchCode = "10-4 Rubber Ducky",
            description = "Drug Selling",
            radius = 0,
            sprite = 51,
            color = 2,
            scale = 1.0,
            length = 3,
        })
    end)
    
    -- else
    -- QBCore.Functions.Notify("You are on a timeout!", "error")
    -- Citizen.SetTimeout(Config.TimeOut, function()
    -- timer = false
    -- end)
    -- end
    else
        QBCore.Functions.Notify("Already Doing Something!", "error")
    end
end

