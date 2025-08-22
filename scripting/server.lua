local QBCore = exports['qb-core']:GetCoreObject()
local NotifyPlayer

local function RegisterItems()
    if Config.Debug then print('Registering items...') end
    
    for itemName, itemData in pairs(Config.Consumables) do
        QBCore.Functions.CreateUseableItem(itemName, function(source, item)
            local Player = QBCore.Functions.GetPlayer(source)
            if not Player then return end
            
            -- Prefer retrieving by slot to ensure we check the exact instance (important for ox_inventory metadata)
            local hasItem = (item and item.slot) and Player.Functions.GetItemBySlot(item.slot) or Player.Functions.GetItemByName(item.name)
            if not hasItem then 
                TriggerClientEvent('QBCore:Notify', source, "You don't have this item!", "error")
                return 
            end
            
            -- Prevent use if durability/quality is depleted (supports qb-inventory and ox_inventory styles)
            local durability
            -- Only consider explicit per-instance metadata, not top-level defaults
            if hasItem.info then
                if hasItem.info.durability ~= nil then durability = hasItem.info.durability end
                if durability == nil and hasItem.info.quality ~= nil then durability = hasItem.info.quality end
            end
            if durability == nil and hasItem.metadata then
                if hasItem.metadata.durability ~= nil then durability = hasItem.metadata.durability end
                if durability == nil and hasItem.metadata.quality ~= nil then durability = hasItem.metadata.quality end
            end

            if durability ~= nil then
                local numericDurability = tonumber(durability)
                if numericDurability ~= nil and numericDurability <= 0 then
                    if Config.Debug then print('Blocked use of', itemName, 'for source', source, 'due to zero durability/quality') end
                    NotifyPlayer(source, Config.Notifications.CantUse)
                    return
                end
            end

            if Config.Debug then print('Item used:', itemName, 'by source:', source, 'slot:', item.slot) end
            TriggerClientEvent('paradise_consumables:client:useItem', source, item.name, item.slot)
        end)
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        RegisterItems()
    end
end)

function NotifyPlayer(source, notifyData, replaceValue)
    if Config.UseOxNotification then
        TriggerClientEvent('ox_lib:notify', source, {
            title = notifyData.title,
            description = replaceValue and string.format(notifyData.description, replaceValue) or notifyData.description,
            type = notifyData.type,
            duration = notifyData.duration
        })
    else
        TriggerClientEvent('QBCore:Notify', source, 
            replaceValue and string.format(notifyData.description, replaceValue) or notifyData.description,
            notifyData.type,
            notifyData.duration
        )
    end
end

RegisterNetEvent('paradise_consumables:server:removeItem', function(itemName, itemSlot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local item = (itemSlot and Player.Functions.GetItemBySlot(itemSlot)) or Player.Functions.GetItemByName(itemName)
    if item then
        if Player.Functions.RemoveItem(itemName, 1, itemSlot) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
            
            local consumable = Config.Consumables[itemName]
            if consumable and consumable.type == 'box' and consumable.gives then
                Player.Functions.AddItem(consumable.gives.item, consumable.gives.amount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[consumable.gives.item], 'add', consumable.gives.amount)
                NotifyPlayer(src, {
                    title = "Box Opened",
                    description = string.format("You got %dx %s", consumable.gives.amount, QBCore.Shared.Items[consumable.gives.item].label),
                    type = "success",
                    duration = 3000
                })
            end
            
            NotifyPlayer(src, {
                title = "Item Removed",
                description = string.format("Removed 1x %s", QBCore.Shared.Items[itemName].label),
                type = "inform",
                duration = 3000
            })
            
            if Config.Debug then print('Item removed:', itemName, 'from player:', src) end
        end
    end
end)

RegisterNetEvent('paradise_consumables:server:addHunger', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local hunger = Player.PlayerData.metadata['hunger'] or 0
    hunger = tonumber(hunger)
    if not hunger then hunger = 0 end
    
    hunger = math.min(100, math.max(0, hunger + amount))
    
    Player.Functions.SetMetaData('hunger', hunger)
    TriggerClientEvent('hud:client:UpdateNeeds', src, hunger, nil)
    if Config.Debug then print('Hunger updated for player:', src, 'New value:', hunger) end
end)

RegisterNetEvent('paradise_consumables:server:addThirst', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local thirst = Player.PlayerData.metadata['thirst'] or 0
    thirst = tonumber(thirst)
    if not thirst then thirst = 0 end
    
    thirst = math.min(100, math.max(0, thirst + amount))
    
    Player.Functions.SetMetaData('thirst', thirst)
    TriggerClientEvent('hud:client:UpdateNeeds', src, nil, thirst)
    if Config.Debug then print('Thirst updated for player:', src, 'New value:', thirst) end
end)

RegisterNetEvent('paradise_consumables:server:removeStress', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local stress = Player.PlayerData.metadata['stress'] or 0
    stress = tonumber(stress)
    if not stress then stress = 0 end
    
    stress = math.min(100, math.max(0, stress - amount))
    
    Player.Functions.SetMetaData('stress', stress)
    TriggerClientEvent('hud:client:UpdateStress', src, stress)
    if Config.Debug then print('Stress updated for player:', src, 'New value:', stress) end
end)

RegisterNetEvent('paradise_consumables:server:heal', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if Config.Debug then print('Healing request received for player:', src, 'Amount:', amount) end
    
    -- Check if player metadata exists and has the required fields
    local metadata = Player.PlayerData.metadata or {}
    local isDead = metadata.isdead or false
    local inLastStand = metadata.inlaststand or false
    
    if not isDead and not inLastStand then
        -- Directly trigger client heal event
        TriggerClientEvent('paradise_consumables:client:heal', src, amount)
        if Config.Debug then print('Healing player:', src, 'Amount:', amount) end
    else
        if Config.Debug then print('Player is dead or in last stand, cannot heal:', src) end
    end
end)