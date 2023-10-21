import React, { useState, useEffect } from "react";
import "./App.css";
import { debugData } from "./utils/debugData";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { fetchNui } from "./utils/fetchNui";
import GasStation from "./components/GasStation";
import ElectricStation from "./components/ElectricStation";

debugData([
  {
    action: "eventHandler",
    data: {
      _value: "Electric-Station",
      _visible: true,
      _isCharging: false,
      _name: "Tesla Supercharger",
      _location: "Grand Senorta Desert, Senora Fwy",
      _currentFuelLevel: 20,
      _chargingPrice: 12,
    },
  },
]);

const App: React.FC = () => {
  useEffect(() => {
    const escapeKeyPressed = (event: KeyboardEvent) => {
      if (event.key === "Escape") {
        fetchNui("hideGasStation");
      }
    };
    window.addEventListener("keydown", escapeKeyPressed);
    return () => {
      window.removeEventListener("keydown", escapeKeyPressed);
    };
  }, []);

  const [isGasStationVisible, setIsGasStationVisible] = useState(false);
  const [gasStationName, setGasStationName] = useState("");
  const [gasStationLocation, setGasStationLocation] = useState("");
  const [currentVehicleFuel, setCurrentVehicleFuel] = useState(0);

  const [isElectroStationVisible, setIsElectroStationVisible] = useState(false);
  const [chargingPrice, setChargingPrice] = useState(0);
  const [isCharging, setIsCharging] = useState(false);

  const [gasStationConfig, setGasStationConfig] = useState({
    petrolPrice: 0,
    dieselPrice: 0,
    petrolCanPrice: 0,
    dieselCanPrice: 0,
  });

  useNuiEvent("init", (data) => {
    setGasStationConfig(data);
  });

  useNuiEvent("eventHandler", (data) => {
    if (data._value === "Gas-Station") {
      setIsGasStationVisible(data._visible);
      setGasStationName(data._name);
      setGasStationLocation(data._location);
      setCurrentVehicleFuel(data._currentFuelLevel);
    } else if (data._value === "close") {
      setIsGasStationVisible(data._visible);
      setIsElectroStationVisible(data._visible);
    } else if (data._value === "Electric-Station") {
      setIsElectroStationVisible(data._visible);
      setGasStationName(data._name);
      setGasStationLocation(data._location);
      setCurrentVehicleFuel(data._currentFuelLevel);
      setChargingPrice(data._chargingPrice);
      setIsCharging(data._isCharging);
    }
  });

  return (
    <>
      {isGasStationVisible && (
        <GasStation
          gasStationConfig={gasStationConfig}
          gasStationName={gasStationName}
          gasStationLocation={gasStationLocation}
          currentVehicleFuel={currentVehicleFuel}
        />
      )}
      {isElectroStationVisible && (
        <ElectricStation
          chargingPrice={chargingPrice}
          gasStationName={gasStationName}
          gasStationLocation={gasStationLocation}
          currentVehicleFuel={currentVehicleFuel}
          isCharging={isCharging}
        />
      )}
    </>
  );
};

export default App;
