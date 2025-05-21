local ESX = exports['es_extended']:getSharedObject()

-- Function to get random item from a tier
local function getRandomItem(tier)
    local items = Config.Items[tier]
    if not items or #items == 0 then return nil end
    
    -- Calculate total chance for tier normalization
    local totalChance = 0
    for _, item in ipairs(items) do
        totalChance = totalChance + item.chance
    end
    
    -- Pick random item based on chance
    local roll = math.random(1, totalChance)
    local currentChance = 0
    
    for _, item in ipairs(items) do
        currentChance = currentChance + item.chance
        if roll <= currentChance then
            local count = math.random(item.min, item.max)
            return { name = item.name, count = count }
        end
    end
    
    return nil
end

-- Function to determine which item tier to give
local function getItemTier()
    local roll = math.random(1, 100)
    local currentChance = 0
    
    -- Order matters here: nothing, common, uncommon, rare
    currentChance = currentChance + Config.TierChances.nothing
    if roll <= currentChance then
        return "nothing"
    end
    
    currentChance = currentChance + Config.TierChances.common
    if roll <= currentChance then
        return "common"
    end
    
    currentChance = currentChance + Config.TierChances.uncommon
    if roll <= currentChance then
        return "uncommon"
    end
    
    return "rare"
end

-- Function to generate rewards
local function generateRewards(containerType)
    local maxItems = Config.MaxItems[containerType] or 1
    local results = {}
    
    -- Determine how many items to give (1 to maxItems)
    local numItems = math.random(1, maxItems)
    for i = 1, numItems do
        local tier = getItemTier()
        if tier ~= "nothing" then
            local item = getRandomItem(tier)
            if item then
                table.insert(results, item)
            end
        end
    end
    
    return results
end

-- Server event to give items to player
RegisterNetEvent('koma_dumpsterdive:getItems')
AddEventHandler('koma_dumpsterdive:getItems', function(containerType)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    if not containerType then return end
    
    -- Validate container type
    if containerType ~= 'dumpster' and containerType ~= 'trashcan' then
        return
    end
    
    -- Get rewards based on container type
    local rewards = generateRewards(containerType)
    
    -- Check if player found anything
    if #rewards == 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'You found nothing useful',
            type = 'error'
        })
        return
    end
    
    -- Instead of pre-checking inventory space, try to add each item individually
    local successfulItems = {}
    
    for _, item in ipairs(rewards) do
        -- Try to add the item directly
        local success = exports.ox_inventory:AddItem(source, item.name, item.count)
        
        if success then
            table.insert(successfulItems, {
                name = item.name,
                count = item.count
            })
        end
    end
    
    -- Show notification based on what was actually added
    if #successfulItems == 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'Your pockets are completely full',
            type = 'error'
        })
        return
    end
    
    -- Show notification
    if #successfulItems == 1 then
        local item = successfulItems[1]
        local itemLabel = exports.ox_inventory:Items()[item.name].label
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'You found ' .. item.count .. 'x ' .. itemLabel,
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'You found ' .. #successfulItems .. ' items!',
            type = 'success'
        })
    end
end)

-- Add some debug commands
ESX.RegisterCommand('dumpsterreward', 'admin', function(xPlayer, args, showError)
    TriggerEvent('koma_dumpsterdive:getItems', args.type or 'dumpster')
end, true, {help = 'Test dumpster rewards', validate = false, arguments = {
    {name = 'type', validate = false, help = 'Container type (dumpster/trashcan)', type = 'string'}
}}) 