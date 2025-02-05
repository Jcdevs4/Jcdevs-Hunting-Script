-- Client-side Hunting Script

local huntingZones = {
    {x = 2089.85, y = 5105.46, z = 45.28},  -- Example spawn location 1
    {x = 2089.85, y = 5105.46, z = 45.28},  -- Example spawn location 2
    {x = 2089.85, y = 5105.46, z = 45.28}, -- Example spawn location 3
}

local animalModel = "a_c_deer"  -- Animal model (can be replaced with any animal)
local animal = nil

-- Function to spawn a random animal in the hunting zones
function SpawnAnimal()
    local randomZone = huntingZones[math.random(1, #huntingZones)]  -- Pick a random hunting zone
    local x, y, z = randomZone.x, randomZone.y, randomZone.z

    -- Load the model
    RequestModel(animalModel)
    while not HasModelLoaded(animalModel) do
        Citizen.Wait(500)
    end

    -- Spawn the animal
    animal = CreatePed(28, GetHashKey(animalModel), x, y, z, 0.0, true, true)
    SetEntityAsMissionEntity(animal, true, true)
    SetPedFleeAttributes(animal, 0, 0)
    SetPedCombatAttributes(animal, 17, true)
    TaskWanderStandard(animal, 10.0, 10)

    -- Inform player that the animal has spawned
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {"Hunting", "A wild deer has appeared nearby!"}
    })
end

-- Function to check if the player is close enough to shoot the animal
function CheckForAnimalKill()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local animalPos = GetEntityCoords(animal)

    local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, animalPos.x, animalPos.y, animalPos.z)
    
    -- Check if player is within 5 meters of the animal and presses 'E' to hunt
    if distance < 5.0 then
        -- Press "E" to kill the animal
        if IsControlJustPressed(0, 38) then  -- 'E' key
            -- Kill the animal (use any method like shooting or stabbing)
            SetEntityHealth(animal, 0)  -- Kill the animal instantly

            -- Reward the player with meat or resources
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                args = {"Hunting", "You have killed the animal and received meat!"}
            })

            -- Optionally, give the player meat or other loot
            GivePlayerLoot()
        end
    end
end

-- Function to give the player loot after killing the animal
function GivePlayerLoot()
    -- Example: Give the player meat (you can expand this to give more items)
    TriggerServerEvent('hunt:giveLoot', "meat", 1)
end

-- Start the hunt after a command
RegisterCommand("hunt", function()
    if animal == nil then
        SpawnAnimal()  -- Spawn the animal when the player types "/hunt"
    end
end, false)

-- Optional: Trigger fire by key press (F5 in this case)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Press "F5" to start the hunt
        if IsControlJustPressed(0, 166) then  -- F5 is keycode 166
            if animal == nil then
                SpawnAnimal()  -- Spawn the animal if it's not already spawned
            end
        end

        -- Check for animal kill interaction
        if animal ~= nil then
            CheckForAnimalKill()
        end
    end
end)
