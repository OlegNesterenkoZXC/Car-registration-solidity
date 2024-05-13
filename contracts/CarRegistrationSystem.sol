// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

contract CarRegistrationSystem is AccessControlEnumerable {
  bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR");
  mapping(string => Car) internal cars;

  mapping (string => uint) public dutiesList;

  
  constructor (string memory _VIN) {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(VALIDATOR_ROLE, msg.sender);

    Car storage car = cars[_VIN];

    car.insurancePolices[0] = InsurancePolicy("1", "11");
    car.insurancePolicesSize++;
    car.insurancePolices[1] = InsurancePolicy("2", "22");
    car.insurancePolicesSize++;
    car.insurancePolices[2] = InsurancePolicy("3", "33");
    car.insurancePolicesSize++;

    car.vehiclePassports[0] = Vehiclepassport("54", unicode"ЖМА", "875473");
    car.vehiclePassportsSize++;

    car.registrationDates[0] = RegistrtionDate(0, 1587795681);
    car.registrationDates[1] = RegistrtionDate(1587795681, 1619331681);
    car.registrationDates[2] = RegistrtionDate(1619331682, 0);
    car.registrationDatesSize += 3;
    
    car.duties.push("AUTO_LICENSE_PLATES");
    car.duties.push("VEHICLE_REGISTRATION_CERTIFICATE");

    dutiesList["AUTO_LICENSE_PLATES"] = 0.006 ether;
    dutiesList["MOTORCYCLE_LICENSE_PLATES"] =  0.0045 ether;
    dutiesList["VEHICLE_REGISTRATION_CERTIFICATE"] =  0.0015 ether;
    dutiesList["CHANGE_PASSPORT_VEHICLE"] =  0.001 ether;
    dutiesList["ISSUANCE_VEHICLE_PASSPORT"] =  0.0024 ether;
  }

  struct Vehiclepassport {
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

    mapping (uint => Vehiclepassport) vehiclePassports;
    uint vehiclePassportsSize;

    mapping (uint => RegistrtionDate) registrationDates;
    uint registrationDatesSize;

    string[] duties;
  }

  function getRegistrationDates (string calldata _VIN) external view returns(RegistrtionDate[] memory) {
    Car storage car = cars[_VIN];
    mapping (uint => RegistrtionDate) storage registrationDatesMapping = car.registrationDates;
    uint sizeRD = car.registrationDatesSize;

    RegistrtionDate[] memory registrationDates = new RegistrtionDate[](sizeRD);

    for (uint i = 0; i < sizeRD; ++i) 
    {
      registrationDates[i] = registrationDatesMapping[i];
    }

    return registrationDates;
  }

  function getInsurancePolices (string calldata _VIN) external view returns(InsurancePolicy[] memory) {
    Car storage car = cars[_VIN];
    mapping (uint => InsurancePolicy) storage insurancePolicesMapping = car.insurancePolices;
    uint sizeIP = car.insurancePolicesSize;

    InsurancePolicy[] memory insurancePolices = new InsurancePolicy[](sizeIP);

    for (uint i = 0; i < sizeIP; ++i) 
    {
      insurancePolices[i] = insurancePolicesMapping[i];
    }

    return insurancePolices;
  }

  function getVehiclePassports (string calldata _VIN) external view returns(Vehiclepassport[] memory) {
    Car storage car = cars[_VIN];
    mapping (uint => Vehiclepassport) storage vehiclePassportsMapping = car.vehiclePassports;
    uint sizeVP = car.vehiclePassportsSize;

    Vehiclepassport[] memory vehiclePassports = new Vehiclepassport[](sizeVP);

    for (uint i = 0; i < sizeVP; ++i) 
    {
      vehiclePassports[i] = vehiclePassportsMapping[i];
    }

    return vehiclePassports;
  }

  function getInsurancePolice (string calldata _VIN, uint _index) 
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

  function addInsurancePolices (string calldata _VIN, InsurancePolicy calldata insurancePolice) external  {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to add insurance police");

    Car storage car = cars[_VIN];

    car.insurancePolices[car.insurancePolicesSize] = insurancePolice;
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
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to add vehicle passport");

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


  function getVehiclepassport (string calldata _VIN, uint _index) 
  external 
  view 
  returns(string memory, string memory, string memory, string memory) {
    Car storage car = cars[_VIN];
    require(_index < car.vehiclePassportsSize, "This vehicle passport does not exist");

    Vehiclepassport memory vp = car.vehiclePassports[_index];

    return (_VIN, vp.region, vp.series, vp.number);
  }

  function getVehiclePassportsSize (string calldata _VIN) external view returns(uint) {
    return cars[_VIN].vehiclePassportsSize;
  }

  function addVehiclepassport (string memory _VIN, string memory _region, string memory _series, string memory _number) 
  external  {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to add vehicle passport");

    Car storage car = cars[_VIN];

    car.vehiclePassports[car.vehiclePassportsSize] = Vehiclepassport(_region, _series, _number);
    car.vehiclePassportsSize++;
  }

  function editVehiclepassport (string memory _VIN, uint _index, string memory _region, string memory _series, string memory _number) external  {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to edit vehicle passport");

    Car storage car = cars[_VIN];
    require(_index < car.vehiclePassportsSize, "This vehicle passport does not exist");

    car.vehiclePassports[_index] = Vehiclepassport(_region, _series, _number);
  }

  function removeVehiclepassport (string memory _VIN, uint _index) external {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to remove vehicle passport");

    Car storage car = cars[_VIN];
    require(_index < car.vehiclePassportsSize, "This vehicle passport does not exist");

    for (uint i = _index; i < car.vehiclePassportsSize - 1; ++i) 
    {
      car.vehiclePassports[i] = car.vehiclePassports[i + 1];
    }

    delete car.vehiclePassports[car.vehiclePassportsSize - 1];
    car.vehiclePassportsSize--;
  }


  function getDuties(string memory _VIN) external view returns(string[] memory) {
    return cars[_VIN].duties;
  }

  function addCarDuty(string calldata _VIN, string calldata _duty) external {
    require(hasRole(VALIDATOR_ROLE, msg.sender), "No permission to add car duty");
    require(dutiesList[_duty] != 0, "Duty does not exists");

    Car storage car = cars[_VIN];

    car.duties.push(_duty);
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

  function isExistsCar(string calldata _VIN) external view returns(bool) {
    Car storage car = cars[_VIN];

    if (car.insurancePolicesSize != 0 || car.vehiclePassportsSize != 0 || car.registrationDatesSize != 0) {
      return true;
    }

    return false;
  }

  function payDuties(string calldata _VIN) external payable {
    uint amount = getAmountDuties(_VIN);
    
    require(amount != 0, "Duties does not exists");
    require(msg.value >= amount, "Not enought ethers");


    uint refund = msg.value - amount;
    if (refund > 0) {
      payable(msg.sender).transfer(refund);
    }
    
    delete cars[_VIN].duties;
  }

  function getBalance () external view returns(uint) {
    return address(this).balance;
  }

  receive() external payable { }

  fallback() external payable { }
}
