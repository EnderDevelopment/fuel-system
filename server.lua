local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('fuel:getFuelLevel', function(source, cb, plate)
    MySQL.Async.fetchScalar('SELECT fuel_level FROM fuel_system WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(fuelLevel)
        if fuelLevel then
            cb(fuelLevel)
        else
            MySQL.Async.execute('INSERT INTO fuel_system (plate, fuel_level) VALUES (@plate, 100)', {
                ['@plate'] = plate
            }, function()
                cb(100)
            end)
        end
    end)
end)

ESX.RegisterServerCallback('fuel:updateFuelLevel', function(source, cb, plate, fuelLevel)
    MySQL.Async.execute('UPDATE fuel_system SET fuel_level = @fuelLevel WHERE plate = @plate', {
        ['@plate'] = plate,
        ['@fuelLevel'] = fuelLevel
    }, function()
        cb(true)
    end)
end)

RegisterNetEvent('fuel:pay')
AddEventHandler('fuel:pay', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.removeAccountMoney('bank', amount)
    end
end)