const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const hre = require('hardhat');

const DUTY = {
  AUTO_LICENSE_PLATES: "AUTO_LICENSE_PLATES",
  MOTORCYCLE_LICENSE_PLATES: "MOTORCYCLE_LICENSE_PLATES",
  VEHICLE_REGISTRATION_CERTIFICATE: "VEHICLE_REGISTRATION_CERTIFICATE",
  CHANGE_PASSPORT_VEHICLE: "CHANGE_PASSPORT_VEHICLE",
  ISSUANCE_VEHICLE_PASSPORT: "ISSUANCE_VEHICLE_PASSPORT"
}

module.exports = buildModule("CarRegistrationSystem", (m) => {
  const owner = m.getAccount(19)
  
  const options = { from: owner }
  const vin = "4S4BRDSC2D2221585"

  const carRegistrationSystem = m.contract("CarRegistrationSystem", [], options)

  addDuty(m, carRegistrationSystem, DUTY.AUTO_LICENSE_PLATES, "0.006", options, 0)
  addDuty(m, carRegistrationSystem, DUTY.MOTORCYCLE_LICENSE_PLATES, "0.0045", options, 1)
  addDuty(m, carRegistrationSystem, DUTY.VEHICLE_REGISTRATION_CERTIFICATE, "0.0015", options, 2)
  addDuty(m, carRegistrationSystem, DUTY.CHANGE_PASSPORT_VEHICLE, "0.001", options, 3)
  addDuty(m, carRegistrationSystem, DUTY.ISSUANCE_VEHICLE_PASSPORT, "0.0024", options, 4)
  
  addCarDuty(m, carRegistrationSystem, vin, DUTY.AUTO_LICENSE_PLATES, options, 5)
  addCarDuty(m, carRegistrationSystem, vin, DUTY.CHANGE_PASSPORT_VEHICLE, options, 6)
  
  addInsurancePolicy(m, carRegistrationSystem, vin, "АА", "11", options, 0)
  addInsurancePolicy(m, carRegistrationSystem, vin, "ББ", "22", options, 1)
  addInsurancePolicy(m, carRegistrationSystem, vin, "ВВ", "33", options, 2)

  addVehiclePassport(m, carRegistrationSystem, vin, "54", "АА", "11", options, 0)
  addVehiclePassport(m, carRegistrationSystem, vin, "54", "ББ", "22", options, 1)
  addVehiclePassport(m, carRegistrationSystem, vin, "54", "ВВ", "33", options, 2)

  addRegistrationDate(m, carRegistrationSystem, vin, 0, 1587795681, options, 0)
  addRegistrationDate(m, carRegistrationSystem, vin, 1587795682, 1619331681, options, 1)
  addRegistrationDate(m, carRegistrationSystem, vin, 1619331682, 0, options, 2)

  
  return { CarRegistrationSystem: carRegistrationSystem };
});

/**
 * 
 * @param {object} m 
 * @param {object} carRegistrationSystem 
 * @param {string} name 
 * @param {string} amount 
 * @param {object} options 
 * @param {string|number} id 
 */
function addDuty (m, carRegistrationSystem, name, amount, options, id) {
  m.call(
    carRegistrationSystem, 
    "addDuty",
    [
      name,
      hre.ethers.parseEther(amount)
    ],
    {
      ...options,
      id: `duty${id}`
    }
  )
}

/**
 * 
 * @param {object} m 
 * @param {object} carRegistrationSystem 
 * @param {string} vin 
 * @param {string} serial 
 * @param {string} number 
 * @param {object} options 
 * @param {string|number} id 
 */
function addInsurancePolicy (m, carRegistrationSystem, vin, serial, number, options, id) {
  m.call(carRegistrationSystem,
    "addInsurancePolicy", 
    [
      vin, 
      [
        serial,
        number
      ]
    ], 
    {
      ...options,
      id: `addInsurancePolicy${id}`
    }
  )
}

/**
 * 
 * @param {object} m 
 * @param {object} carRegistrationSystem 
 * @param {string} vin 
 * @param {string|number} region 
 * @param {string|number} serial 
 * @param {string|number} number 
 * @param {object} options 
 * @param {string|number} id 
 */
function addVehiclePassport (m, carRegistrationSystem, vin, region, serial, number, options, id) {
  m.call(carRegistrationSystem,
    "addVehiclePassport", 
    [
      vin, 
      [ 
        region,
        serial,
        number
      ]
    ], 
    {
      ...options,
      id: `addVehiclePassport${id}`
    }
  )
}

/**
 * 
 * @param {object} m 
 * @param {object} carRegistrationSystem 
 * @param {string} vin 
 * @param {string} duty 
 * @param {object} options 
 * @param {string|number} id 
 */
function addCarDuty (m, carRegistrationSystem, vin, duty, options, id) {
  m.call(carRegistrationSystem,
    "addCarDuty", 
    [
      vin,
      duty
    ], 
    {
      ...options,
      id: `duty${id}`
    }
  )
}

/**
 * 
 * @param {object} m 
 * @param {object} carRegistrationSystem 
 * @param {string} vin 
 * @param {number} start 
 * @param {number} end 
 * @param {object} options 
 * @param {string|number} id 
 */
function addRegistrationDate (m, carRegistrationSystem, vin, start, end, options, id) {
  m.call(carRegistrationSystem,
    "addRegistrationDate", 
    [
      vin,
      [
        start,
        end
      ]
    ], 
    {
      ...options,
      id: `addRegistrationDate${id}`
    }
  )
}
