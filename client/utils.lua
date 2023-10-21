function hideNui()
  SetNuiFocus(0,0)
  TriggerScreenblurFadeOut(1000)
  SendNUIMessage({
    action = "eventHandler",
    data = {
      _value = "close",
      _visible = false
    }
  })
end

RegisterNUICallback('hideGasStation', function()
  hideNui()
end)

function openGasStation(gName, gLoc, fuelTank)
  SetNuiFocus(1,1)
  TriggerScreenblurFadeIn(1000)
  SendNUIMessage({
    action = "eventHandler",
    data = {
      _value = "Gas-Station",
      _visible = true,
      _name = gName,
      _location = gLoc,
      _currentFuelLevel = fuelTank
    }
  })
end

function openElectricStation(gName, gLoc, fuelTank, isCharging)
  SetNuiFocus(1,1)
  TriggerScreenblurFadeIn(1000)
  SendNUIMessage({
    action = "eventHandler",
    data = {
      _value = "Electric-Station",
      _visible = true,
      _name = gName,
      _location = gLoc,
      _currentFuelLevel = fuelTank,
      _chargingPrice = Config.ChargingPrice,
      _isCharging = isCharging
    }
  })
end
