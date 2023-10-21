import React, { useState } from "react";
import "./gasstation.css";
import FuelSlider from "./FuelSlider";
import { fetchNui } from "../utils/fetchNui";
import MonetizationOnIcon from "@mui/icons-material/MonetizationOn";
import PaymentIcon from "@mui/icons-material/Payment";
import FuelCan from "./FuelCan";

interface GasStationProps {
  gasStationConfig: {
    petrolPrice: number;
    dieselPrice: number;
    petrolCanPrice: number;
    dieselCanPrice: number;
  };
  gasStationName: string;
  gasStationLocation: string;
  currentVehicleFuel: number;
}

const GasStation: React.FC<GasStationProps> = (props) => {
  const {
    gasStationConfig,
    gasStationName,
    gasStationLocation,
    currentVehicleFuel,
  } = props;

  const [selectedFuel, setSelectedFuel] = useState("Petrol");

  const [sliderValue, setSliderValue] = useState(1);
  const handleSliderChange = (value: number) => {
    setSliderValue(value);
  };

  const [currentPrice, setCurrenPrice] = useState(gasStationConfig.petrolPrice);

  const changeFuelState = (fuelType: string) => {
    setSelectedFuel(fuelType);
    let getPrice =
      fuelType === "Petrol"
        ? gasStationConfig.petrolPrice
        : fuelType === "Diesel"
        ? gasStationConfig.dieselPrice
        : 0;
    setCurrenPrice(getPrice);
    setSliderValue(1);
  };

  const processPayment = (paymentMethod: string) => {
    const paymentData = {
      _fuelType: selectedFuel,
      _tankValue: sliderValue,
      _paymentType: paymentMethod,
    };
    fetchNui("payment", paymentData);
  };

  const [isFuelCanOpen, setFuelCanOpen] = useState(false);

  const openFuelCan = () => {
    setFuelCanOpen(true);
  };

  const closeFuelCan = () => {
    setFuelCanOpen(false);
  };
  return (
    <>
      <div className='app-gas-station'>
        <h1>{gasStationName}</h1>
        <h3>{gasStationLocation}</h3>
        <div className='app-gas-station__buttons-container'>
          <button
            onClick={() => changeFuelState("Petrol")}
            id={selectedFuel === "Petrol" ? "active" : ""}
          >
            Petrol
          </button>
          <button
            onClick={() => changeFuelState("Diesel")}
            id={selectedFuel === "Diesel" ? "active" : ""}
          >
            Diesel
          </button>
          <button onClick={openFuelCan}>Fuel Can</button>
        </div>
        <div className='app-gas-station__center-container'>
          <div className='app-gas-station__center-container__sliderUpper-desc'>
            <p>Select type of fuel that you want to tank</p>
            <p>
              Slected fuel: <span>{selectedFuel}</span>
            </p>
          </div>
          <div className='app-gas-station__slider'>
            <FuelSlider
              fTank={100 - Math.round(currentVehicleFuel)}
              value={sliderValue}
              onChange={handleSliderChange}
            />
          </div>

          <div className='app-gas-station__slider-desc'>
            <p>Avaivable fuel</p>
            <span id='afuel'>{100 - Math.round(currentVehicleFuel)}L</span>
          </div>
          <div className='app-gas-station__fuel-managment'>
            <p>
              Fuel to tank: <span>{sliderValue}L</span>
            </p>
            <p>
              Total price:
              <span>{currentPrice * sliderValue}$</span>
            </p>
          </div>
          <div className='app-gas-station__payment-methods'>
            <button onClick={() => processPayment("cash")}>
              <MonetizationOnIcon />
              <p>Cash</p>
            </button>
            <button onClick={() => processPayment("card")}>
              <PaymentIcon />
              <p>Card</p>
            </button>
          </div>
        </div>

        <div className='app-gas-station__left-container-sidebar'>
          <p>
            Price per liter: <span>{currentPrice}$</span>
          </p>
        </div>
      </div>
      {isFuelCanOpen && (
        <FuelCan
          isOpen={isFuelCanOpen}
          onClose={closeFuelCan}
          petrolCanPrice={gasStationConfig.petrolCanPrice}
          dieselCanPrice={gasStationConfig.dieselCanPrice}
        />
      )}
    </>
  );
};

export default GasStation;
