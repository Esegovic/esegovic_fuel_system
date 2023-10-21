import React, { useContext, useState, useEffect } from "react";
import "./electricstation.css";
import ProgressBar from "./ProgressBar";
import MonetizationOnIcon from "@mui/icons-material/MonetizationOn";
import PaymentIcon from "@mui/icons-material/Payment";
import { fetchNui } from "../utils/fetchNui";

interface ElectricStationProps {
  chargingPrice: number;
  gasStationName: string;
  gasStationLocation: string;
  currentVehicleFuel: number;
  isCharging: boolean;
}
const ElectricStation: React.FC<ElectricStationProps> = (props) => {
  const {
    chargingPrice,
    gasStationName,
    gasStationLocation,
    currentVehicleFuel,
    isCharging,
  } = props;

  const ePaymentProcess = (paymentMethod: string) => {
    const paymentData = {
      _tankValue: currentVehicleFuel,
      _paymentType: paymentMethod,
    };
    fetchNui("epayment", paymentData);
  };

  return (
    <div>
      <div className='app-electric-station'>
        <h1>{gasStationName}</h1>
        <h3>{gasStationLocation}</h3>
        <div className='app-electric-station__charging-percent'>
          <p>
            STATUS:{" "}
            <span style={{ color: isCharging ? "#3966af" : "#b84646" }}>
              {isCharging ? "CHARGING..." : "NOT CHARGING"}
            </span>
          </p>
          <p>
            Current Battery Level: <span>{currentVehicleFuel}%</span>
          </p>
          <ProgressBar currentBatteryLevel={currentVehicleFuel} />
        </div>
        <div className='app-electric-station__bottom_side'>
          <span>{chargingPrice}$ per kWh</span>
          <div className='app-electric-station__bottom_side-customLine'></div>
          <div className='app-electric-station__bottom_side-buttons-group'>
            <button onClick={() => ePaymentProcess("card")}>
              <MonetizationOnIcon />
              Cash
            </button>
            <button onClick={() => ePaymentProcess("card")}>
              <PaymentIcon />
              Bank
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ElectricStation;
