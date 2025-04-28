local QBCore = exports['qb-core']:GetCoreObject()
local activeProps = {}
local activeEffects = {}
local activeTimerBar = nil
---- Effects 
local alienEffect = false
local weedEffect = false
local trevorEffect = false
local turboEffect = false
local rampageEffect = false
local focusEffect = false
local NightVisionEffect = false
local thermalEffect = false
local drunkEffect = false
local drunkLevel = 0
local maxDrunkLevel = 100

local function IsPlayerAbleToUse()
    local Player = QBCore.Functions.GetPlayerData()
    if not Player then return false end
    local playerState = Player.metadata['inlaststand'] or Player.metadata['isdead']
    return not playerState
end

local function NotifyPlayer(notifyData, replaceValue)
    if Config.UseOxNotification then
        lib.notify({
            title = notifyData.title,
            description = replaceValue and string.format(notifyData.description, replaceValue) or notifyData.description,
            type = notifyData.type,
            duration = notifyData.duration
        })
    else
        QBCore.Functions.Notify(
            replaceValue and string.format(notifyData.description, replaceValue) or notifyData.description,
            notifyData.type,
            notifyData.duration
        )
    end
end

local function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(10)
    end
end

local function HandleAnimationAndProps(itemName, consumable)
    local ped = PlayerPedId()
    
    if consumable.progress.anim then
        LoadAnimDict(consumable.progress.anim.dict)
        TaskPlayAnim(ped, consumable.progress.anim.dict, consumable.progress.anim.clip, 
            8.0, -8.0, -1, consumable.progress.anim.flag, 0, false, false, false)
    end
    
    if consumable.progress.prop then
        LoadModel(consumable.progress.prop.model)
        
        local coords = GetEntityCoords(ped)
        local prop = CreateObject(consumable.progress.prop.model, coords.x, coords.y, coords.z + 0.2, true, true, true)
        local boneIndex = GetPedBoneIndex(ped, consumable.progress.prop.bone)
        
        AttachEntityToEntity(prop, ped, boneIndex,
            consumable.progress.prop.pos.x, consumable.progress.prop.pos.y, consumable.progress.prop.pos.z,
            consumable.progress.prop.rot.x, consumable.progress.prop.rot.y, consumable.progress.prop.rot.z,
            true, true, false, true, 1, true)
            
        activeProps[itemName] = prop
    end
end

local function CleanupPropsAndAnims(itemName, consumable)
    if activeProps[itemName] then
        DeleteObject(activeProps[itemName])
        activeProps[itemName] = nil
    end
    
    if consumable.progress.anim then
        StopAnimTask(PlayerPedId(), consumable.progress.anim.dict, consumable.progress.anim.clip, 1.0)
    end
end

local function RemoveTimerBar()
    activeTimerBar = nil
end

local function AddTimerBar(text, data)
    if activeTimerBar then
        RemoveTimerBar()
    end
    
    activeTimerBar = {
        text = text,
        endTime = data.endTime
    }
    
    CreateThread(function()
        while activeTimerBar do
            if GetGameTimer() >= activeTimerBar.endTime then
                RemoveTimerBar()
                break
            end
            
            local remaining = math.ceil((activeTimerBar.endTime - GetGameTimer()) / 1000)
            
            SetTextScale(0.5, 0.5)
            SetTextFont(4)
            SetTextOutline()
            SetTextColour(255, 255, 255, 255)
            SetTextRightJustify(true)
            SetTextWrap(0.0, 0.95)
            
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName(string.format('%s: %ds', activeTimerBar.text, remaining))
            EndTextCommandDisplayText(0.95, 0.94)
            
            Wait(0)
        end
    end)
end

local function HandleStatusEffect(itemName, stats)
    if not stats then return end
    
    if activeEffects[itemName] then
        if Config.Debug then print('Clearing existing effect for:', itemName) end
        RemoveTimerBar()
        ClearTimecycleModifier()
        if activeEffects[itemName].timer then
            ClearTimeout(activeEffects[itemName].timer)
        end
        activeEffects[itemName] = nil
    end
    
    if stats.screen then
        local duration = stats.time or 30000 -- Default to 30 seconds if not specified
        if stats.screen == "turbo" then CreateThread(function() TurboEffect(duration) end) end
        if stats.screen == "focus" then CreateThread(function() FocusEffect(duration) end) end
        if stats.screen == "rampage" then CreateThread(function() RampageEffect(duration) end) end
        if stats.screen == "weed" then CreateThread(function() WeedEffect(duration) end) end
        if stats.screen == "trevor" then CreateThread(function() TrevorEffect(duration) end) end
        if stats.screen == "nightvision" then CreateThread(function() NightVisionEffect(duration) end) end
        if stats.screen == "thermal" then CreateThread(function() ThermalEffect(duration) end) end
        if stats.screen == "drunk" then 
            drunkLevel = math.min(maxDrunkLevel, drunkLevel + (stats.amount or 20))
            CreateThread(function() DrunkEffect(duration) end) 
        end
    end
    
    local effectDuration = stats.time or 10000
    local effectAmount = stats.amount or 2
    local startTime = GetGameTimer()
    local endTime = startTime + effectDuration
    
    if stats.effect then
        local timerText = string.upper(stats.effect) .. " EFFECT"
        AddTimerBar(timerText, {endTime = endTime})
    end
    
    activeEffects[itemName] = {
        startTime = startTime,
        endTime = endTime,
        effect = stats.effect,
        amount = effectAmount
    }
    
    activeEffects[itemName].timer = SetTimeout(effectDuration, function()
        if Config.Debug then print('Effect ended for:', itemName) end
        RemoveTimerBar()
        ClearTimecycleModifier()
        activeEffects[itemName] = nil
    end)
    
    CreateThread(function()
        while activeEffects[itemName] do
            local effect = activeEffects[itemName]
            if effect and GetGameTimer() < effect.endTime then
                if effect.effect == "heal" then
                    local ped = PlayerPedId()
                    local health = GetEntityHealth(ped)
                    if Config.Debug then print('Current health:', health, 'Healing amount:', effect.amount) end
                    if health < 200 then
                        local newHealth = math.min(200, health + effect.amount)
                        SetEntityHealth(ped, newHealth)
                        if Config.Debug then print('New health:', newHealth) end
                    end
                elseif effect.effect == "stamina" then
                    local stamina = GetPlayerStamina(PlayerId())
                    if stamina < 100 then
                        SetPlayerStamina(PlayerId(), math.min(100, stamina + effect.amount))
                    end
                elseif effect.effect == "armor" then
                    local armor = GetPedArmour(PlayerPedId())
                    if armor < 100 then
                        SetPedArmour(PlayerPedId(), math.min(100, armor + effect.amount))
                    end
                end
            else
                break
            end
            Wait(1000)
        end
    end)
end

local function StartProgress(consumable, cb)
    if Config.UseOxProgressBar then
        if lib.progressCircle({
            duration = consumable.progress.duration,
            label = consumable.progress.label,
            useWhileDead = false,
            canCancel = consumable.progress.canCancel,
            disable = consumable.progress.disable,
        }) then
            cb(true)
        else
            cb(false)
        end
    else
        QBCore.Functions.Progressbar("use_consumable", consumable.progress.label, 
            consumable.progress.duration, false, consumable.progress.canCancel, {
            disableMovement = consumable.progress.disable.move,
            disableCarMovement = consumable.progress.disable.car,
            disableMouse = false,
            disableCombat = consumable.progress.disable.combat,
        }, {}, {}, {}, function()
            cb(true)
        end, function()
            cb(false)
        end)
    end
end

local function UseConsumable(itemName)
    if not IsPlayerAbleToUse() then
        NotifyPlayer(Config.Notifications.CantUse)
        return
    end

    local consumable = Config.Consumables[itemName]
    if not consumable then 
        if Config.Debug then print('Invalid consumable:', itemName) end
        NotifyPlayer(Config.Notifications.NoItem)
        return 
    end

    HandleAnimationAndProps(itemName, consumable)
    
    StartProgress(consumable, function(success)
        if success then
            if consumable.type == 'box' then
                if consumable.removeOnUse == true then
                    TriggerServerEvent('paradise_consumables:server:removeItem', itemName)
                end
                NotifyPlayer(Config.Notifications.ItemUsed, consumable.label)
            else
                if consumable.effects then
                    if consumable.effects.hunger then
                        TriggerServerEvent('paradise_consumables:server:addHunger', consumable.effects.hunger)
                    end
                    
                    if consumable.effects.thirst then
                        TriggerServerEvent('paradise_consumables:server:addThirst', consumable.effects.thirst)
                    end
                    
                    if consumable.effects.stress then
                        TriggerServerEvent('paradise_consumables:server:removeStress', math.abs(consumable.effects.stress))
                    end
                    
                    if consumable.effects.heal then
                        TriggerServerEvent('paradise_consumables:server:heal', consumable.effects.heal)
                    end
                end
                
                if consumable.stats then
                    HandleStatusEffect(itemName, consumable.stats)
                end
                
                if consumable.removeOnUse == true then
                    TriggerServerEvent('paradise_consumables:server:removeItem', itemName)
                end
                
                NotifyPlayer(Config.Notifications.ItemUsed, consumable.label)
            end
        else
            NotifyPlayer(Config.Notifications.CantUse)
        end
        
        CleanupPropsAndAnims(itemName, consumable)
    end)
end

RegisterNetEvent('paradise_consumables:client:useItem', function(itemName)
    if Config.Debug then print('Using item:', itemName) end
    UseConsumable(itemName)
end)

RegisterNetEvent('paradise_consumables:client:heal', function(amount)
    if Config.Debug then print('Client heal event received, amount:', amount) end
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    
    -- Handle both positive and negative healing
    local newHealth = health + amount
    
    -- Ensure health stays within valid range (0-200)
    newHealth = math.max(0, math.min(200, newHealth))
    
    if Config.Debug then print('Current health:', health, 'Healing amount:', amount, 'New health:', newHealth) end
    
    SetEntityHealth(ped, newHealth)
end)

-- Screen Effects Credit : Jimathy

function AlienEffect(duration)
    if alienEffect then return else alienEffect = true end
    if Config.Debug then print("^5Debug^7: ^3AlienEffect^7() ^2activated") end
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(math.random(5000, 8000))
    local Ped = PlayerPedId()
    local animDict = "MOVE_M@DRUNK@VERYDRUNK"
    loadAnimDict(animDict)
    SetPedCanRagdoll(Ped, true)
    ShakeGameplayCam('DRUNK_SHAKE', 2.80)
    SetTimecycleModifier("Drunk")
    SetPedMovementClipset(Ped, animDict, 1)
    SetPedMotionBlur(Ped, true)
    SetPedIsDrunk(Ped, true)
    Wait(1500)
    SetPedToRagdoll(Ped, 5000, 1000, 1, 0, 0, 0)
    Wait(duration - 1500)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(Ped, 0)
    SetPedIsDrunk(Ped, false)
    SetPedMotionBlur(Ped, false)
    AnimpostfxStopAll()
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    AnimpostfxPlay("DrugsMichaelAliensFight", 3.0, 0)
    Wait(math.random(45000, 60000))
    AnimpostfxPlay("DrugsMichaelAliensFightOut", 3.0, 0)
    AnimpostfxStop("DrugsMichaelAliensFightIn")
    AnimpostfxStop("DrugsMichaelAliensFight")
    AnimpostfxStop("DrugsMichaelAliensFightOut")
    alienEffect = false
    if Config.Debug then print("^5Debug^7: ^3AlienEffect^7() ^2stopped") end
end

function WeedEffect(duration)
    if weedEffect then return else weedEffect = true end
    if Config.Debug then print("^5Debug^7: ^3WeedEffect^7() ^2activated") end
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(3000)
    AnimpostfxPlay("DrugsMichaelAliensFight", 3.0, 0)
    Wait(duration - 3000)
    AnimpostfxPlay("DrugsMichaelAliensFightOut", 3.0, 0)
    AnimpostfxStop("DrugsMichaelAliensFightIn")
    AnimpostfxStop("DrugsMichaelAliensFight")
    AnimpostfxStop("DrugsMichaelAliensFightOut")
    weedEffect = false
    if Config.Debug then print("^5Debug^7: ^3WeedEffect^7() ^2stopped") end
end

function TrevorEffect(duration)
    if trevorEffect then return else trevorEffect = true end
    if Config.Debug then print("^5Debug^7: ^3TrevorEffect^7() ^2activated") end
    AnimpostfxPlay("DrugsTrevorClownsFightIn", 3.0, 0)
    Wait(3000)
    AnimpostfxPlay("DrugsTrevorClownsFight", 3.0, 0)
    Wait(duration - 3000)
    AnimpostfxPlay("DrugsTrevorClownsFightOut", 3.0, 0)
    AnimpostfxStop("DrugsTrevorClownsFight")
    AnimpostfxStop("DrugsTrevorClownsFightIn")
    AnimpostfxStop("DrugsTrevorClownsFightOut")
    trevorEffect = false
    if Config.Debug then print("^5Debug^7: ^3TrevorEffect^7() ^2stopped") end
end

function TurboEffect(duration)
    if turboEffect then return else turboEffect = true end
    if Config.Debug then print("^5Debug^7: ^3TurboEffect^7() ^2activated") end
    AnimpostfxPlay('RaceTurbo', 0, true)
    SetTimecycleModifier('rply_motionblur')
    ShakeGameplayCam('SKY_DIVING_SHAKE', 0.25)
    Wait(duration)
    StopGameplayCamShaking(true)
    SetTransitionTimecycleModifier('default', 0.35)
    Wait(1000)
    ClearTimecycleModifier()
    AnimpostfxStop('RaceTurbo')
    turboEffect = false
    if Config.Debug then print("^5Debug^7: ^3TurboEffect^7() ^2stopped") end
end

function RampageEffect(duration)
    if rampageEffect then return else rampageEffect = true end
    if Config.Debug then print("^5Debug^7: ^3RampageEffect^7() ^2activated") end
    AnimpostfxPlay('Rampage', 0, true)
    SetTimecycleModifier('rply_motionblur')
    ShakeGameplayCam('SKY_DIVING_SHAKE', 0.25)
    Wait(duration)
    StopGameplayCamShaking(true)
    SetTransitionTimecycleModifier('default', 0.35)
    Wait(1000)
    ClearTimecycleModifier()
    AnimpostfxStop('Rampage')
    rampageEffect = false
    if Config.Debug then print("^5Debug^7: ^3RampageEffect^7() ^2stopped") end
end

function FocusEffect(duration)
    if focusEffect then return else focusEffect = true end
    if Config.Debug then print("^5Debug^7: ^3FocusEffect^7() ^2activated") end
    Wait(1000)
    AnimpostfxPlay('FocusIn', 0, true)
    Wait(duration - 1000)
    AnimpostfxStop('FocusIn')
    focusEffect = false
    if Config.Debug then print("^5Debug^7: ^3FocusEffect^7() ^2stopped") end
end

function NightVisionEffect(duration)
    if NightVisionEffect then return else NightVisionEffect = true end
    if Config.Debug then print("^5Debug^7: ^3NightVisionEffect^7() ^2activated") end
    SetNightvision(true)
    Wait(duration)
    SetNightvision(false)
    SetSeethrough(false)
    NightVisionEffect = false
    if Config.Debug then print("^5Debug^7: ^3NightVisionEffect^7() ^2stopped") end
end

function ThermalEffect(duration)
    if thermalEffect then return else thermalEffect = true end
    if Config.Debug then print("^5Debug^7: ^3ThermalEffect^7() ^2activated") end
    SetNightvision(true)
    SetSeethrough(true)
    Wait(duration)
    SetNightvision(false)
    SetSeethrough(false)
    thermalEffect = false
    if Config.Debug then print("^5Debug^7: ^3ThermalEffect^7() ^2stopped") end
end

function DrunkEffect(duration)
    if drunkEffect then return else drunkEffect = true end
    if Config.Debug then print("^5Debug^7: ^3DrunkEffect^7() ^2activated - Level:", drunkLevel) end
    
    local ped = PlayerPedId()
    local animDict = "move_m@drunk@verydrunk"
    
    LoadAnimDict(animDict)
    SetPedMovementClipset(ped, animDict, 1.0)
    SetPedMotionBlur(ped, true)
    SetPedIsDrunk(ped, true)
    
    local shakeIntensity = (drunkLevel / maxDrunkLevel) * 3.0
    ShakeGameplayCam('DRUNK_SHAKE', shakeIntensity)
    SetTimecycleModifier("spectator5")
    
    CreateThread(function()
        local startTime = GetGameTimer()
        while drunkEffect and GetGameTimer() - startTime < duration do
            if math.random() < (drunkLevel / maxDrunkLevel) then
                SetPedToRagdoll(ped, 1500, 1500, 0, 0, 0, 0)
            end
            Wait(10000)
        end
        
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(ped, 0)
        SetPedIsDrunk(ped, false)
        SetPedMotionBlur(ped, false)
        ShakeGameplayCam('DRUNK_SHAKE', 0.0)
        drunkEffect = false
        if Config.Debug then print("^5Debug^7: ^3DrunkEffect^7() ^2stopped") end
    end)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for itemName, prop in pairs(activeProps) do
            if DoesEntityExist(prop) then
                DeleteEntity(prop)
            end
        end
        activeProps = {}
        for itemName, effect in pairs(activeEffects) do
            if effect.timer then
                ClearTimeout(effect.timer)
            end
        end
        RemoveTimerBar()
        ClearTimecycleModifier()
        activeEffects = {}
    end
end)