Config = {
    DieselPrice = 8, --@param int (per liter)
    PetrolPrice = 5, --@param int (per liter)
    PetrolCanPrice = 275, --@param int (per Can)
    DieselCanPrice = 325, --@param int (per Can)
    ChargingPrice = 3, --@param int (per 10 sec)
    ShowBlips = true, --@param boolean
    ManageFuel = true, --@param boolean
}

Fuel_Consumption = {
    ["Petrol"] = { -- key = percentage RPM, value = comp. fuel divided by 10
        [1.0] = 1.4,
        [0.9] = 1.2,
        [0.8] = 1.0,
        [0.7] = 0.9,
        [0.6] = 0.8,
        [0.5] = 0.7,
        [0.4] = 0.5,
        [0.3] = 0.4,
        [0.2] = 0.2,
        [0.1] = 0.1,
        [0.0] = 0.1,
    },
    ["Diesel"] = {
        [1.0] = 1.0,
        [0.9] = 0.9,
        [0.8] = 0.8,
        [0.7] = 0.7,
        [0.6] = 0.6,
        [0.5] = 0.5,
        [0.4] = 0.3,
        [0.3] = 0.2,
        [0.2] = 0.1,
        [0.1] = 0.1,
        [0.0] = 0.1,
    },
    ["Electro"] = { 
        [1.0] = 1.8,
        [0.9] = 1.6,
        [0.8] = 1.4,
        [0.7] = 1.2,
        [0.6] = 1.0,
        [0.5] = 0.9,
        [0.4] = 0.8,
        [0.3] = 0.5,
        [0.2] = 0.3,
        [0.1] = 0.2,
        [0.0] = 0.1,
    }
}

Vehicles = {
    -- Only add Diesel and Electro Cars here (all other will be petrol)
    ["Diesel"] = {
        "adder",
        "sultan"
    },
    ["Electro"] = {
        "teslapd"
    }
}