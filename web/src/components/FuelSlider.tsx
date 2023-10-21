import React from "react";
import Slider from "@mui/material/Slider";

interface CustomSliderProps {
  value: number;
  onChange: (newValue: number) => void;
  fTank: number;
}

const FuelSlider: React.FC<CustomSliderProps> = ({
  value,
  onChange,
  fTank,
}) => {
  const handleChange = (event: Event, newValue: number | number[]) => {
    onChange(newValue as number);
  };

  return (
    <>
      <Slider
        value={value}
        min={1}
        max={fTank}
        onChange={handleChange}
        defaultValue={1}
        aria-label='ios slider'
        valueLabelDisplay='on'
        disabled={false}
        className='custom-slider'
        sx={{
          "& .MuiSlider-thumb": {
            height: 10,
            width: 3,
            borderRadius: "1px",
            backgroundColor: "#fff",
            "&:focus, &:hover, &.Mui-active, &.Mui-focusVisible": {
              boxShadow: "inherit",
            },
          },
          "& *": {
            background: "#274472",
            color: "dark",
          },
          "& .MuiSlider-valueLabel": {
            backgroundColor: "#274472",
          },
          "& .MuiSlider-track": {
            border: "none",
          },
        }}
      />
    </>
  );
};

export default FuelSlider;
