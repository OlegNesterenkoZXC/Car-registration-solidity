// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

contract CarRegistrationSystem is AccessControlEnumerable {
  bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR");
  mapping(string => Car) internal cars;

  mapping (string => uint) public dutiesList;

  
  constructor (string memory _VIN, string memory _data) {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

    Car storage car = cars["123"];

    car.insurancePolices[0] = InsurancePolicy("1", "11");
    car.insurancePolicesSize++;
    car.insurancePolices[1] = InsurancePolicy("2", "22");
    car.insurancePolicesSize++;
    car.insurancePolices[2] = InsurancePolicy("3", "33");
    car.insurancePolicesSize++;

    car.vehiclePasports[0] = VehiclePasport("54", unicode"ЖМА", "875473");
    car.vehiclePasportsSize++;

    car.registrationDates[0] = RegistrtionDate(0, 1619331680);
    car.registrationDates[1] = RegistrtionDate(1587795681, 1619331681);
    car.registrationDates[2] = RegistrtionDate(1619331682, 0);
    car.registrationDatesSize = 3;
    
    car.duties.push("AUTO_LICENSE_PLATES");
    car.duties.push("VEHICLE_REGISTRATION_SERTIFICATE");

    dutiesList["AUTO_LICENSE_PLATES"] = 0.006 ether;
    dutiesList["MOTORCICLE_LICENSE_PLATES"] =  0.0045 ether;
    dutiesList["VEHICLE_REGISTRATION_SERTIFICATE"] =  0.0015 ether;
    dutiesList["CHANGE_PASSPORT_VEHICLE"] =  0.001 ether;
    dutiesList["ISSUANCE_VEHICLE_PASSPORT"] =  0.0024 ether;
  }

  struct VehiclePasport {
    string region;
    string series;
    string number;
  }

  struct InsurancePolicy {
    string series;
    string number;   
  }

  struct RegistrtionDate {
    uint start;
    uint end;
  }

  struct Car {
    mapping (uint => InsurancePolicy) insurancePolices;
    uint insurancePolicesSize;

    mapping (uint => VehiclePasport) vehiclePasports;
    uint vehiclePasportsSize;

    mapping (uint => RegistrtionDate) registrationDates;
    uint registrationDatesSize;

    string[] duties;
  }



  function _getInsurancePolices (string calldata _VIN) external view returns(InsurancePolicy[] memory, uint) {
    Car storage car = cars[_VIN];
    mapping (uint => InsurancePolicy) storage insurancePolicesMapping = car.insurancePolices;
    uint sizeIP = car.insurancePolicesSize;

    InsurancePolicy[] memory insurancePolices = new InsurancePolicy[](sizeIP);

    for (uint i = 0; i < sizeIP; ++i) 
    {
      insurancePolices[i] = insurancePolicesMapping[i];
    }

    return (insurancePolices, sizeIP);
  }

  function _getVehiclePasports (string calldata _VIN) internal view returns(VehiclePasport[] memory, uint) {
    Car storage car = cars[_VIN];
    mapping (uint => VehiclePasport) storage vehiclePasportsMapping = car.vehiclePasports;
    uint sizeVP = car.vehiclePasportsSize;

    VehiclePasport[] memory vehiclePasports = new VehiclePasport[](sizeVP);

    for (uint i = 0; i < sizeVP; ++i) 
    {
      vehiclePasports[i] = vehiclePasportsMapping[i];
    }

    return (vehiclePasports, sizeVP);
  }

  function getInsurancePolices (string calldata _VIN, uint _index) 
  external 
  view 
  returns(string memory, string memory, string memory) {
    Car storage car = cars[_VIN];
    require(_index < car.insurancePolicesSize, "This vehicle passport does not exist");

    InsurancePolicy memory ip = car.insurancePolices[_index];

    return (_VIN, ip.series, ip.number);
  }

  function getInsurancePolicesSize (string calldata _VIN) external view returns(uint) {
    return cars[_VIN].insurancePolicesSize;
  }

  function addInsurancePolices (string memory _VIN, string memory _series, string memory _number) external  {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to add insurance police");

    Car storage car = cars[_VIN];

    car.insurancePolices[car.insurancePolicesSize] = InsurancePolicy(_series, _number);
    car.insurancePolicesSize++;
  }

  function editInsurancePolices (string memory _VIN, uint _index, string memory _series, string memory _number) external  {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to edit insurance police");

    Car storage car = cars[_VIN];
    require(_index < car.insurancePolicesSize, "This insurance police does not exist");

    car.insurancePolices[_index] = InsurancePolicy(_series, _number);
  }

  function removeInsurancePolices (string memory _VIN, uint _index) external {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to remove insurance police");

    Car storage car = cars[_VIN];
    require(_index < car.insurancePolicesSize, "This insurance police does not exist");

    for (uint i = _index; i < car.insurancePolicesSize - 1; ++i) 
    {
      car.insurancePolices[i] = car.insurancePolices[i + 1];
    }

    delete car.insurancePolices[car.insurancePolicesSize - 1];
    car.insurancePolicesSize--;
  }


  function getRegistrationDate (string calldata _VIN, uint _index) 
  external 
  view 
  returns(string memory, uint, uint) {
    Car storage car = cars[_VIN];
    require(_index < car.registrationDatesSize, "This vehicle passport does not exist");

    RegistrtionDate memory rd = car.registrationDates[_index];

    return (_VIN, rd.start, rd.end);
  }

  function getRegistrationDatesSize (string calldata _VIN) external view returns(uint) {
    return cars[_VIN].registrationDatesSize;
  }

  function addRegistrationDate (string memory _VIN, uint _start, uint _end) external  {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to add vehicle pasport");

    Car storage car = cars[_VIN];

    car.registrationDates[car.registrationDatesSize] = RegistrtionDate(_start, _end);
    car.registrationDatesSize++;
  }

  function editRegistrationDate (string memory _VIN, uint _index, uint _start, uint _end) external  {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to edit registration date");

    Car storage car = cars[_VIN];
    require(_index < car.registrationDatesSize, "This registration date does not exist");

    car.registrationDates[_index] = RegistrtionDate(_start, _end);
  }

  function removeRegistrationDate (string memory _VIN, uint _index) external {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to remove registration date");

    Car storage car = cars[_VIN];
    require(_index < car.registrationDatesSize, "This insurance police does not exist");

    for (uint i = _index; i < car.registrationDatesSize - 1; ++i) 
    {
      car.registrationDates[i] = car.registrationDates[i + 1];
    }

    delete car.registrationDates[car.registrationDatesSize - 1];
    car.registrationDatesSize--;
  }


  function getVehiclePasport (string calldata _VIN, uint _index) 
  external 
  view 
  returns(string memory, string memory, string memory, string memory) {
    Car storage car = cars[_VIN];
    require(_index < car.vehiclePasportsSize, "This vehicle passport does not exist");

    VehiclePasport memory vp = car.vehiclePasports[_index];

    return (_VIN, vp.region, vp.series, vp.number);
  }

  function getVehiclePasportsSize (string calldata _VIN) external view returns(uint) {
    return cars[_VIN].vehiclePasportsSize;
  }

  function addVehiclePasport (string memory _VIN, string memory _region, string memory _series, string memory _number) 
  external  {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to add vehicle pasport");

    Car storage car = cars[_VIN];

    car.vehiclePasports[car.vehiclePasportsSize] = VehiclePasport(_region, _series, _number);
    car.vehiclePasportsSize++;
  }

  function editVehiclePasport (string memory _VIN, uint _index, string memory _region, string memory _series, string memory _number) external  {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to edit vehicle pasport");

    Car storage car = cars[_VIN];
    require(_index < car.vehiclePasportsSize, "This vehicle pasport does not exist");

    car.vehiclePasports[_index] = VehiclePasport(_region, _series, _number);
  }

  function removeVehiclePasport (string memory _VIN, uint _index) external {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to remove vehicle pasport");

    Car storage car = cars[_VIN];
    require(_index < car.vehiclePasportsSize, "This vehicle pasport does not exist");

    for (uint i = _index; i < car.vehiclePasportsSize - 1; ++i) 
    {
      car.vehiclePasports[i] = car.vehiclePasports[i + 1];
    }

    delete car.vehiclePasports[car.vehiclePasportsSize - 1];
    car.vehiclePasportsSize--;
  }


  function getDuties(string memory _VIN) external view returns(string[] memory) {
    return cars[_VIN].duties;
  }

  function getDutiesSize(string memory _VIN) external view returns(uint) {
    return cars[_VIN].duties.length;
  }

  function getAmountDuties(string memory _VIN) public view returns(uint) {
    string[] memory carDuties = cars[_VIN].duties;

    uint amount = 0;
    for (uint i = 0; i < carDuties.length; ++i) 
    {
      amount += dutiesList[carDuties[i]];
    }
    
    return amount;
  }

  function editDuty(string calldata name, uint amount) external {
    require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "No permission to add a duty");

    dutiesList[name] = amount;
  }

  function removeDuty(string calldata name) external {
    require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "No permission to remove the duty");

    delete dutiesList[name];
  }
}
