local ESX = exports['es_extended']:getSharedObject()
local searchedObjects = {}
local isSearching = false
local lastSearch = 0

-- Function to check if container has been searched recently
local function canSearch(entity)
    if isSearching then return false end
    
    local currentTime = GetGameTimer()
    
    -- Check global cooldown
    if (currentTime - lastSearch) < (Config.GlobalCooldown * 1000) then
        lib.notify({
            description = 'You need to wait before searching again',
            type = 'error'
        })
        return false
    end
    
    -- Store entity instead of network ID to avoid warnings
    local entityHash = tostring(entity) .. GetEntityModel(entity)
    if searchedObjects[entityHash] and (currentTime - searchedObjects[entityHash]) < (Config.SearchCooldown * 1000) then
        lib.notify({
            description = 'This has been searched recently',
            type = 'error'
        })
        return false
    end
    
    return true
end

-- Function to play animation based on container type
local function playSearchAnimation(containerType)
    isSearching = true
    
    local animData = Config.Animations[containerType]
    lib.requestAnimDict(animData.dict)
    
    TaskPlayAnim(PlayerPedId(), animData.dict, animData.anim, 8.0, -8.0, animData.duration, animData.flags, 0, false, false, false)
    
    if lib.progressCircle({
        duration = animData.duration,
        label = 'Searching...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        position = 'bottom',
    }) then
        TriggerServerEvent('koma_dumpsterdive:getItems', containerType)
    else
        -- Cancelled
        lib.notify({
            description = 'You stopped searching',
            type = 'inform'
        })
    end
    
    ClearPedTasks(PlayerPedId())
    isSearching = false
    lastSearch = GetGameTimer()
end

-- Function to check if entity is a dumpster or a trash can
local function getContainerType(entity)
    local model = GetEntityModel(entity)
    
    for _, dumpsterModel in ipairs(Config.Models.dumpsters) do
        if model == dumpsterModel then
            return 'dumpster'
        end
    end
    
    for _, trashModel in ipairs(Config.Models.trashcans) do
        if model == trashModel then
            return 'trashcan'
        end
    end
    
    return nil
end

-- Search container function
local function searchContainer(entity)
    if not entity or not DoesEntityExist(entity) then return end
    
    local containerType = getContainerType(entity)
    if not containerType then return end
    
    if not canSearch(entity) then
        return
    end
    
    -- Store entity with hash instead of network ID
    local entityHash = tostring(entity) .. GetEntityModel(entity)
    searchedObjects[entityHash] = GetGameTimer()
    
    -- Play animation and get items
    playSearchAnimation(containerType)
end

-- Register targets for dumpsters
local options = {
    {
        name = 'koma_search_container',
        icon = 'fas fa-search',
        label = 'Search',
        onSelect = function(data)
            searchContainer(data.entity)
        end,
        canInteract = function(entity)
            if not IsPedAPlayer(entity) then
                local containerType = getContainerType(entity)
                return containerType ~= nil
            end
            return false
        end
    }
}

-- Add ox_target support
for _, model in pairs(Config.Models.dumpsters) do
    exports.ox_target:addModel(model, options)
end

for _, model in pairs(Config.Models.trashcans) do
    exports.ox_target:addModel(model, options)
end

-- Keymapping (optional)
RegisterCommand('searchnearestbin', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    local object = nil
    local minDist = 2.0
    local closestObject = nil
    local closestDistance = minDist
    
    -- Check for nearby dumpsters
    for _, model in ipairs(Config.Models.dumpsters) do
        object = GetClosestObjectOfType(coords.x, coords.y, coords.z, minDist, model, false, false, false)
        if DoesEntityExist(object) then
            local objectCoords = GetEntityCoords(object)
            local distance = #(coords - objectCoords)
            if distance < closestDistance then
                closestObject = object
                closestDistance = distance
            end
        end
    end
    
    -- Check for nearby trash cans
    for _, model in ipairs(Config.Models.trashcans) do
        object = GetClosestObjectOfType(coords.x, coords.y, coords.z, minDist, model, false, false, false)
        if DoesEntityExist(object) then
            local objectCoords = GetEntityCoords(object)
            local distance = #(coords - objectCoords)
            if distance < closestDistance then
                closestObject = object
                closestDistance = distance
            end
        end
    end
    
    if closestObject then
        searchContainer(closestObject)
    else
        lib.notify({
            description = 'No containers nearby',
            type = 'error'
        })
    end
end, false)

RegisterKeyMapping('searchnearestbin', 'Search nearest bin', 'keyboard', '')

-- Reset search records when player loads
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    searchedObjects = {}
    lastSearch = 0
end)

-- Reset objects when player respawns
AddEventHandler('esx:onPlayerDeath', function()
    isSearching = false
end) 