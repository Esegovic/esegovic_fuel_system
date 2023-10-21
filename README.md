<div align="center">
    <img href="https://esegovic-developments.tebex.io/" width="150" src="https://dunb17ur4ymx4.cloudfront.net/webstore/logos/b55e3aace5a9d4e8b0fbde77a09d8aed9e629ccc.png" alt="no-alt" />
</div>
<h1 align="center">FiveM Fuel System</h1>

<div align="center">
  <h1>Lua & React (Typescript)</h1>
</div>

<div align="center">

[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/project-error/pe-utils/master/LICENSE)
[![Discord](https://img.shields.io/discord/791854454760013827?label=Our%20Discord)](https://discord.gg/thuCaKFdaa)

</div>



## Usage

```
local vehicle = cache.vehicle or GetPlayersLastVehicle()
local fuel = Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
```

## Requirements

- [ox_lib](https://github.com/overextended/ox_lib)
- [ESX](https://github.com/esx-framework/esx_core)

## Installation

Download the latest releases and put them in your `resources` folder.

## Additional Notes

This script is based on:

- [fivem-react-boilerplate-lua](https://github.com/project-error/fivem-react-boilerplate-lua) (Check Docs if you want to edit the script)
  
Need further support? Join our [Discord](https://discord.gg/thuCaKFdaa)!
