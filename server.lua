-- Server-side Hunting Script

RegisterServerEvent('hunt:giveLoot')
AddEventHandler('hunt:giveLoot', function(item, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)  -- If you're using ESX
    -- If you're not using ESX, use an alternative method to get the player object.
    if item == "meat" then
        -- Give the player 1 meat item (you can change this to suit your system)
        xPlayer.addInventoryItem('meat', quantity)  -- Assuming you have a "meat" item in your inventory system
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"Hunting", "You have received some meat!"}
        })
    end
end)
