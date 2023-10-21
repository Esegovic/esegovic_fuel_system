if not lib.checkDependency('ox_lib', '3.0.0', true) then return end

lib.locale()

local isFueling, isCharging, nearestGasStation, nearestDistance, currentPercentage = false, false, nil, 30, 0;
local lastVehicle = cache.vehicle or GetPlayersLastVehicle()

local function createBlip(loc, type)
    if type then
	    local blip = AddBlipForCoord(loc)
	    SetBlipSprite(blip, 361)
	    SetBlipDisplay(blip, 4)
	    SetBlipScale(blip, 0.6)
	    SetBlipColour(blip, 6)
	    SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(locale('fuel_station_blip'))
	    EndTextCommandSetBlipName(blip)
    else
        local blip = AddBlipForCoord(loc)
	    SetBlipSprite(blip, 361)
	    SetBlipDisplay(blip, 4)
	    SetBlipScale(blip, 0.6)
	    SetBlipColour(blip, 3)
	    SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(locale('electro_station_blip'))
	    EndTextCommandSetBlipName(blip)
    end

	return blip
end

if Config.ShowBlips then
    for coords, data in pairs(GasStations) do
        if data.fType == 'gas' then
            createBlip(coords, true)
        else
            createBlip(coords, false)
        end
    end
end

local function Text3D(coords, text, size, font)
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(vector - camCoords)

    if not size then size = 1 end
    if not font then font = 0 end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0, 0.55 * scale)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(vector.xyz, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

function DrawTextOnScreen(text, scale, r, g, b, a)
    local screenWidth, screenHeight = GetActiveScreenResolution()
    local screenX = screenWidth / 2
    local screenY = screenHeight

    SetTextFont(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.45, 0.85)
end

local function setFuel(state, vehicle, fuel)
	if DoesEntityExist(vehicle) then
		if fuel < 0 then fuel = 0 end
        
		SetVehicleFuelLevel(vehicle, fuel)

		if state.fuel then state:set('fuel', fuel) end
	end
end

local function manageFuel(state, veh)
    local fuel = state.fuel;
    local fuelType = state.fuelType
    if GetIsVehicleEngineRunning(veh) then
        local currentRpm = GetVehicleCurrentRpm(veh)
        local roundedRpm = math.floor(currentRpm * 10) / 10
		local newFuel = fuel - Fuel_Consumption[fuelType][roundedRpm] * 1.0
        setFuel(state, veh, newFuel)
    end
end

local function fuelingProcess(liters)
    isFueling = true
    TaskTurnPedToFaceEntity(cache.ped, lastVehicle, 500)
	Wait(500)
	CreateThread(function()
		lib.progressCircle({
			duration = liters * 100,
			useWhileDead = false,
            label = locale('fueling'),
			canCancel = true,
			disable = {
				move = true,
				car = true,
				combat = true,
			},
			anim = {
				dict = 'timetable@gardener@filling_can',
				clip = 'gar_ig_5_filling_can',
			},
		})

		isFueling = false
        local vehicle = cache.vehicle or GetPlayersLastVehicle()
        local fuel = Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
        TriggerServerEvent('esegovic_fuel.fuelingDone', fuel, liters, NetworkGetNetworkIdFromEntity(vehicle))
	end)
end

local chargingTime = 0

local function CountAndStopCharging()
    while currentPercentage < 100 do
        Wait(1000)
        currentPercentage = currentPercentage + 1
    end
    lib.notify({
        type = 'success',
        label = locale('fuel_station_notify_label'),
        description = locale('veh_charge_done')}
    )
    isCharging = false
    FreezeEntityPosition(lastVehicle, false)
    local vehicle = cache.vehicle or GetPlayersLastVehicle()
    TriggerServerEvent("esegovic.vehicleCharged", NetworkGetNetworkIdFromEntity(vehicle))
end

local function round(number)
    local fractionalPart = number - math.floor(number)
    if fractionalPart < 0.5 then
        return math.floor(number)
    else
        return math.ceil(number)
    end
end


local function ChargeVehicle(kWh)
    lib.notify({
        type = 'success',
        label = locale('fuel_station_notify_label'),
        description = locale('veh_charge_start')}
    )
    isCharging = true
    FreezeEntityPosition(lastVehicle, true)
    currentPercentage = round(kWh)

    Citizen.CreateThread(function()
        CountAndStopCharging()
    end)

    while isCharging do
        Wait(0)
        DrawTextOnScreen(locale('3d_veh_chraging')..currentPercentage.."%", 0.5, 255, 255, 255, 255)
    end
end

RegisterNUICallback('payment', function(data, cb)
    local paymentMethod = data._paymentType;
    local tankValue = tonumber(data._tankValue);
    local fuelType = data._fuelType;
    if fuelType == Entity(lastVehicle).state.fuelType then
        lib.callback('esegovic_fuel.checkMoney', false, function(done)
            if done then
                hideNui()
                fuelingProcess(tankValue)
            else
                hideNui()
            end
          end, paymentMethod, tankValue, fuelType)
    else
        hideNui()
        lib.notify({
            type = 'error',
            label = locale('fuel_station_notify_label'),
            description = locale('not_same_fuel_type', Entity(lastVehicle).state.fuelType)}
        )
    end
    cb({})
end)

RegisterNUICallback('epayment', function(data, cb)
    local paymentMethod = data.paymentMethod
    local tankValue = round(100 - data._tankValue)

    if tankValue == 0 then 
        hideNui() 
        lib.notify({
            type = 'error',
            label = locale('fuel_station_notify_label'),
            description = locale('veh_100%')}
        )
        return
    end

    lib.callback('esegovic_fuel.canCharge', false, function(done)
        if done then
            hideNui()
            ChargeVehicle(tankValue)
        else
            hideNui()
        end
      end, paymentMethod, tankValue)
    
    cb({})
end)

RegisterNUICallback('jerrycan', function(data, cb)
    local jerryCanType = data;
    lib.callback('esegovic_fuel.buyJerryCan', false, function(success)
        if done then
            hideNui()
        else
            hideNui()
        end
    end, jerryCanType)
    cb({})
end)

lib.onCache('seat', function(seat)
	if cache.vehicle then
		lastVehicle = cache.vehicle
	end
end)

CreateThread(function ()
    while true do
        Wait(2000)
        local pCoords = GetEntityCoords(cache.ped)
        for coords, gasStationData in pairs(GasStations) do
            local distance = #(pCoords - coords)
        
            if distance < nearestDistance then
                nearestGasStation = gasStationData
                break
            else
                nearestGasStation = nil
            end
        end
    end
end)

CreateThread(function ()
    while true do
        Wait(0)
        if nearestGasStation ~= nil then
            local pumpCoords = nearestGasStation.PumpObjectsCoords
            local pumpType = nearestGasStation.fType
            for _, coords in pairs(pumpCoords) do
                local pCoords = GetEntityCoords(cache.ped)
                local distance = #(pCoords - coords)
                local vehicleInRange = lastVehicle and #(GetEntityCoords(lastVehicle) - coords) <= 3
                local isElectric = Entity(lastVehicle).state.fuelType == 'Electro'
                if distance < 10 and vehicleInRange then
                    local inVehicle = IsPedInAnyVehicle(cache.ped, false)
                    if not isElectric and pumpType == 'gas' then
                        if inVehicle then
                            Text3D(coords, locale('player_in_car'), 0.5)
                        end
                        if distance < 2 and not inVehicle then
                            Text3D(coords, locale('player_interaction'), 0.5)
                            if distance < 2 then
                                if IsControlJustReleased(0, 38) and not isFueling then                            
                                    openGasStation(nearestGasStation.GasStation_Name, nearestGasStation.Zone_Street_Name, Entity(lastVehicle).state.fuel)
                                end
                            end
                        end
                    elseif isElectric and pumpType == 'electric' then
                        if inVehicle then
                            Text3D(coords, locale('player_in_car_electro'), 0.5)
                        end
                        if distance < 2 and not inVehicle then
                            Text3D(coords, locale('player_interaction_electro'), 0.5)
                            if distance < 2 then
                                if IsControlJustReleased(0, 38) and not isCharging then
                                    openElectricStation(nearestGasStation.GasStation_Name, nearestGasStation.Zone_Street_Name, round(Entity(lastVehicle).state.fuel), isCharging)                      
                                end
                            end
                        end
                    end
                end
            end
        else
            Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
	if Config.ManageFuel then
		while true do
			Citizen.Wait(2000)
            local ped = cache.ped
			local vehicle = cache.vehicle
			if IsPedInAnyVehicle(ped) then
				if GetPedInVehicleSeat(vehicle,-1) == ped then
                    if GetVehicleClass(vehicle) == 13 then return end
                    local state = Entity(vehicle).state
					if not state.fuel then
                        local vehicleModel = GetEntityModel(vehicle)
                        local fuelCategory
                        
                        for k,v in pairs(Vehicles) do
                            for _, model in pairs(v) do
                                if vehicleModel == GetHashKey(model) then
                                    fuelCategory = k
                                    break
                                end
                            end
                        end
                        TriggerServerEvent('esegovic_fuel.CreateStateBag', NetworkGetNetworkIdFromEntity(vehicle), GetVehicleFuelLevel(vehicle), fuelCategory or "Petrol")
                        while not state.fuel and not state.fuelType do Wait(0) end
                    end
                    manageFuel(state,vehicle)
				end
			end
		end
	end
end)

local playerLoaded = false
CreateThread(function ()
    while not playerLoaded do
        Wait(500)
        SendNUIMessage({
            action = 'init',
            data = {
                petrolPrice = Config.PetrolPrice,
                dieselPrice = Config.DieselPrice,
                petrolCanPrice = Config.PetrolCanPrice,
                dieselCanPrice = Config.DieselCanPrice
            }
        })
        playerLoaded = true
    end
end)


-- TODO: Jerry Can Items Usage