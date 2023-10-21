import React, { useEffect } from "react";
import "./progressbar.css";

interface ProgressBarProps {
  currentBatteryLevel: number;
}

const ProgressBar: React.FC<ProgressBarProps> = ({ currentBatteryLevel }) => {
  useEffect(() => {
    const power = Math.round(currentBatteryLevel / 10);
    const bars = document.querySelectorAll(".battery .bar");

    bars.forEach((bar, index) => {
      if (index < power) {
        bar.classList.add("active");
      } else {
        bar.classList.remove("active");
      }
    });
  }, [currentBatteryLevel]);

  return (
    <div id='project_container'>
      <div id='projectbox'>
        <div className='battery'>
          <div className='bar' data-power='10'></div>
          <div className='bar' data-power='20'></div>
          <div className='bar' data-power='30'></div>
          <div className='bar' data-power='40'></div>
          <div className='bar' data-power='50'></div>
          <div className='bar' data-power='60'></div>
          <div className='bar' data-power='70'></div>
          <div className='bar' data-power='80'></div>
          <div className='bar' data-power='90'></div>
          <div className='bar' data-power='100'></div>
        </div>
      </div>
    </div>
  );
};

export default ProgressBar;
