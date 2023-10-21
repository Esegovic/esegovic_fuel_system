import React, { MouseEventHandler } from "react";
import "./fuelcan.css";
import { fetchNui } from "../utils/fetchNui";
import petrolCanImg from "../assets/petrolcan.png";
import dieselCanImg from "../assets/dieselcan.png";

interface FuelCanProps {
  isOpen: boolean;
  onClose: () => void;
  petrolCanPrice: number;
  dieselCanPrice: number;
}

const FuelCan: React.FC<FuelCanProps> = ({
  isOpen,
  onClose,
  petrolCanPrice,
  dieselCanPrice,
}) => {
  if (!isOpen) {
    return null;
  }

  const buyFuelCan = (fuelType: string) => {
    fetchNui<any>("jerrycan", fuelType);
  };

  return (
    <div className='fuel-can__container'>
      <div className='fuel-can__container-content'>
        <h1>What Fuel Can do you want to buy?</h1>
        <div
          className='fuel-can__container-diesel'
          onClick={() => buyFuelCan("diesel")}
        >
          <h4>Diesel Can 50L</h4>
          <img src={dieselCanImg} id='image-blue-filter' alt='Petrol Can' />
          <span>{petrolCanPrice}$</span>
        </div>
        <div
          className='fuel-can__container-petrol'
          onClick={() => buyFuelCan("petrol")}
        >
          <h4>Petrol Can 50L</h4>
          <img src={petrolCanImg} id='image-red-filter' alt='Diesel Can' />
          <span>{dieselCanPrice}$</span>
        </div>

        <button id='close-fuel-can' onClick={onClose}>
          Close
        </button>
      </div>
    </div>
  );
};

export default FuelCan;
