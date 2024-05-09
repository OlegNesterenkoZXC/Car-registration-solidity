const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("CarRegistrationSystem", (m) => {
  const owner = m.getAccount(19)
  const CarRegistrationSystem = m.contract("CarRegistrationSystem", ['4S4BRDSC2D2221585', ''], { from: owner });

  

  return { CarRegistrationSystem };
});
