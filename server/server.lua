lib.locale()

lib.callback.register('esegovic_fuel.checkMoney', function(source, paymentMethod, tankValue, fuelType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local isPetrol = (fuelType == 'Petrol')
    local isCash = (paymentMethod == 'cash')
    local pricePerLiter = isPetrol and Config.PetrolPrice or Config.DieselPrice
    local amountToRemove = pricePerLiter * tankValue
    local targetAccount = isCash and 'money' or 'bank'
    local playerMoney = xPlayer.getAccount(targetAccount).money
    local hasEnoughMoney = playerMoney >= amountToRemove
    local success = false
    local notificationData = {
        type = hasEnoughMoney and 'success' or 'error',
        label = locale('fuel_station_notify_label'),
        description = hasEnoughMoney and locale('fuel_station_pay', amountToRemove, tankValue, fuelType) or locale('fuel_station_no_money')
    }
    
    if hasEnoughMoney then
        xPlayer.removeAccountMoney(targetAccount, amountToRemove)
        success = true
    end
    
    TriggerClientEvent('ox_lib:notify', src, notificationData)
    
    return success

end)

lib.callback.register('esegovic_fuel.buyJerryCan', function(source, jerryType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local isPetrol = (jerryType == 'petrol')
    local amountToRemove = isPetrol and Config.PetrolCanPrice or Config.DieselCanPrice
    local itemToAdd = isPetrol and 'jerrycan_petrol' or 'jerrycan_diesel'
    local playerMoney = xPlayer.getMoney()
    local hasEnoughMoney = playerMoney >= amountToRemove
    local success = false
    local notificationData = {
        type = hasEnoughMoney and 'success' or 'error',
        label = locale('fuel_station_notify_label'),
        description = hasEnoughMoney and locale('fuel_station_jerrycan', jerryType, amountToRemove) or locale('fuel_station_no_money_jerrycan')
    }
    
    if hasEnoughMoney then
        xPlayer.removeMoney(amountToRemove)
        xPlayer.addInventoryItem(itemToAdd, 1)
        success = true
    end
    
    TriggerClientEvent('ox_lib:notify', src, notificationData)
    
    return success

end)

lib.callback.register('esegovic_fuel.canCharge', function(source, paymentMethod, tankValue)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local isCash = (paymentMethod == 'cash')
    local pricePerkWh = Config.ChargingPrice
    local amountToRemove = pricePerkWh * tankValue
    local targetAccount = isCash and 'money' or 'bank'
    local playerMoney = xPlayer.getAccount(targetAccount).money
    local hasEnoughMoney = playerMoney >= amountToRemove
    local success = false
    local notificationData = {
        type = hasEnoughMoney and 'success' or 'error',
        label = locale('fuel_station_notify_label'),
        description = hasEnoughMoney and locale('fuel_station_pay_charge', amountToRemove, tankValue) or locale('fuel_station_no_money_chrage')
    }
    
    if hasEnoughMoney then
        xPlayer.removeAccountMoney(targetAccount, amountToRemove)
        success = true
    end
    
    TriggerClientEvent('ox_lib:notify', src, notificationData)
    
    return success

end)

RegisterNetEvent('esegovic_fuel.CreateStateBag', function(networkId, vehicleFuel, fuelType)
    --@https://docs.fivem.net/docs/scripting-manual/networking/state-bags/
	local vehicle = NetworkGetEntityFromNetworkId(networkId)
	local state = Entity(vehicle).state
    Entity(vehicle).state.fuelType = fuelType

	if not state.fuel and GetEntityType(vehicle) == 2 and NetworkGetEntityOwner(vehicle) == source then
		state:set('fuel', vehicleFuel or 100, true)
	end

end)

RegisterNetEvent('esegovic_fuel.fuelingDone', function(fuel, newFuel, networkID)
    local fuel = math.floor(fuel)
    if fuel < 0 then return end

    local vehicle = NetworkGetEntityFromNetworkId(networkID)
    if not DoesEntityExist(vehicle) then return end

    local state = Entity(vehicle).state
    if not state then return end

    local fuelToSet = math.min(100, fuel + newFuel)
    state:set('fuel', fuelToSet, true)
end)

RegisterNetEvent('esegovic.vehicleCharged', function(networkID)
    local fuel = 100

    local vehicle = NetworkGetEntityFromNetworkId(networkID)
    if not DoesEntityExist(vehicle) then return end

    local state = Entity(vehicle).state
    if not state then return end

    state:set('fuel', 100, true)
end)