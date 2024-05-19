// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

contract CarRegistrationSystem is AccessControlEnumerable {
  bytes32 public constant EDITOR_ROLE = keccak256("EDITOR");

  mapping(string => Car) internal cars;
  mapping (string => uint) public dutiesList;


  constructor (string memory _VIN) {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(EDITOR_ROLE, msg.sender);

    Car storage car = cars[_VIN];

    car.insurancePolicies[0] = InsurancePolicy("1", "11");
    car.insurancePoliciesSize++;
    car.insurancePolicies[1] = InsurancePolicy("2", "22");
    car.insurancePoliciesSize++;
    car.insurancePolicies[2] = InsurancePolicy("3", "33");
    car.insurancePoliciesSize++;

    car.vehiclePassports[0] = VehiclePassport("54", unicode"ЖМА", "875473");
    car.vehiclePassportsSize++;

    car.registrationDates[0] = RegistrationDate(0, 1587795681);
    car.registrationDates[1] = RegistrationDate(1587795681, 1619331681);
    car.registrationDates[2] = RegistrationDate(1619331682, 0);
    car.registrationDatesSize += 3;
    
    car.duties.push("AUTO_LICENSE_PLATES");
    car.duties.push("VEHICLE_REGISTRATION_CERTIFICATE");

    dutiesList["AUTO_LICENSE_PLATES"] = 0.006 ether;
    dutiesList["MOTORCYCLE_LICENSE_PLATES"] =  0.0045 ether;
    dutiesList["VEHICLE_REGISTRATION_CERTIFICATE"] =  0.0015 ether;
    dutiesList["CHANGE_PASSPORT_VEHICLE"] =  0.001 ether;
    dutiesList["ISSUANCE_VEHICLE_PASSPORT"] =  0.0024 ether;
  }


  struct VehiclePassport {
    string region;
    string series;
    string number;
  }

  struct InsurancePolicy {
    string series;
    string number;   
  }

  struct RegistrationDate {
    uint start;
    uint end;
  }

  struct Car {
    mapping (uint => InsurancePolicy) insurancePolicies;
    uint insurancePoliciesSize;

    mapping (uint => VehiclePassport) vehiclePassports;
    uint vehiclePassportsSize;

    mapping (uint => RegistrationDate) registrationDates;
    uint registrationDatesSize;

    string[] duties;
  }


  modifier hasEditorRole (string memory message) {
    require(hasRole(EDITOR_ROLE, msg.sender), message);
    _;
  }

  modifier hasAdminRole (string memory message) {
    require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), message);
    _;
  }


  function getInsurancePolicy (string calldata _VIN, uint _index) 
  external 
  view 
  returns(InsurancePolicy memory) {
    Car storage car = cars[_VIN];
    require(_index < car.insurancePoliciesSize, "This vehicle passport does not exist");

    return car.insurancePolicies[_index];
  }

  function getInsurancePolicies (string calldata _VIN) 
  external 
  view 
  returns(InsurancePolicy[] memory) {
    Car storage car = cars[_VIN];

    mapping (uint => InsurancePolicy) storage insurancePoliciesMapping = car.insurancePolicies;
    uint sizeIP = car.insurancePoliciesSize;

    InsurancePolicy[] memory insurancePolicies = new InsurancePolicy[](sizeIP);

    for (uint i = 0; i < sizeIP; ++i) 
    {
      insurancePolicies[i] = insurancePoliciesMapping[i];
    }

    return insurancePolicies;
  }  

  function getInsurancePoliciesSize (string calldata _VIN) 
  external 
  view
  returns(uint) {
    return cars[_VIN].insurancePoliciesSize;
  }
  
  function addInsurancePolicy (string calldata _VIN, InsurancePolicy calldata _insurancePolicy) 
  external 
  hasEditorRole("No permission to add insurance policy") {
    Car storage car = cars[_VIN];

    car.insurancePolicies[car.insurancePoliciesSize] = _insurancePolicy;
    car.insurancePoliciesSize++;
  }

  function editInsurancePolicy (string calldata _VIN, uint _index, InsurancePolicy calldata _insurancePolicy)
  external
  hasEditorRole("No permission to edit insurance policy") {
    Car storage car = cars[_VIN];
    require(_index < car.insurancePoliciesSize, "This insurance policy does not exist");

    car.insurancePolicies[_index] = _insurancePolicy;
  }

  function removeInsurancePolicy (string calldata _VIN, uint _index)
  external 
  hasEditorRole("No permission to remove insurance policy") {
    Car storage car = cars[_VIN];
    require(_index < car.insurancePoliciesSize, "This insurance policy does not exist");

    for (uint i = _index; i < car.insurancePoliciesSize - 1; ++i) 
    {
      car.insurancePolicies[i] = car.insurancePolicies[i + 1];
    }

    delete car.insurancePolicies[car.insurancePoliciesSize - 1];
    car.insurancePoliciesSize--;
  }


  function getRegistrationDates (string calldata _VIN) 
  external 
  view 
  returns(RegistrationDate[] memory) {
    Car storage car = cars[_VIN];

    mapping (uint => RegistrationDate) storage registrationDatesMapping = car.registrationDates;
    uint sizeRD = car.registrationDatesSize;

    RegistrationDate[] memory registrationDates = new RegistrationDate[](sizeRD);

    for (uint i = 0; i < sizeRD; ++i) 
    {
      registrationDates[i] = registrationDatesMapping[i];
    }

    return registrationDates;
  }

  function getRegistrationDate (string calldata _VIN, uint _index) 
  external 
  view 
  returns(RegistrationDate memory) {
    Car storage car = cars[_VIN];
    require(_index < car.registrationDatesSize, "This registration date does not exist");

    return car.registrationDates[_index];
  }

  function getRegistrationDatesSize (string calldata _VIN) external view returns(uint) {
    return cars[_VIN].registrationDatesSize;
  }

  function addRegistrationDate (string calldata _VIN, RegistrationDate calldata _registrationDate)
  external 
  hasEditorRole("No permission to add registration date") {
    Car storage car = cars[_VIN];

    car.registrationDates[car.registrationDatesSize] = _registrationDate;
    car.registrationDatesSize++;
  }

  function editRegistrationDate (string calldata _VIN, uint _index, RegistrationDate calldata _registrationDate) 
  external
  hasEditorRole("No permission to edit registration date") {
    Car storage car = cars[_VIN];

    require(_index < car.registrationDatesSize, "This registration date does not exist");

    car.registrationDates[_index] = _registrationDate;
  }

  function removeRegistrationDate (string calldata _VIN, uint _index) 
  external 
  hasEditorRole("No permission to remove registration date") {
    Car storage car = cars[_VIN];

    require(_index < car.registrationDatesSize, "This registration date does not exist");

    for (uint i = _index; i < car.registrationDatesSize - 1; ++i) 
    {
      car.registrationDates[i] = car.registrationDates[i + 1];
    }

    delete car.registrationDates[car.registrationDatesSize - 1];
    car.registrationDatesSize--;
  }


  function getVehiclePassports (string calldata _VIN) 
  external 
  view 
  returns(VehiclePassport[] memory) {
    Car storage car = cars[_VIN];

    mapping (uint => VehiclePassport) storage vehiclePassportsMapping = car.vehiclePassports;
    uint sizeVP = car.vehiclePassportsSize;

    VehiclePassport[] memory vehiclePassports = new VehiclePassport[](sizeVP);

    for (uint i = 0; i < sizeVP; ++i) 
    {
      vehiclePassports[i] = vehiclePassportsMapping[i];
    }

    return vehiclePassports;
  }

  function getVehiclePassport (string calldata _VIN, uint _index) 
  external 
  view 
  returns(VehiclePassport memory) {
    Car storage car = cars[_VIN];
    require(_index < car.vehiclePassportsSize, "This vehicle passport does not exist");

    return car.vehiclePassports[_index];
  }

  function getVehiclePassportsSize (string calldata _VIN) external view returns(uint) {
    return cars[_VIN].vehiclePassportsSize;
  }

  function addVehiclePassport (string calldata _VIN, VehiclePassport calldata _vehiclePassport) 
  external
  hasEditorRole("No permission to add vehicle passport") {
    Car storage car = cars[_VIN];

    car.vehiclePassports[car.vehiclePassportsSize] = _vehiclePassport;
    car.vehiclePassportsSize++;
  }

  function editVehiclePassport (string calldata _VIN, uint _index, VehiclePassport calldata _vehiclePassport) 
  external
  hasEditorRole("No permission to edit vehicle passport") {
    Car storage car = cars[_VIN];

    require(_index < car.vehiclePassportsSize, "This vehicle passport does not exist");

    car.vehiclePassports[_index] = _vehiclePassport;
  }

  function removeVehiclePassport (string calldata _VIN, uint _index) 
  external
  hasEditorRole("No permission to remove vehicle passport") {
    Car storage car = cars[_VIN];

    require(_index < car.vehiclePassportsSize, "This vehicle passport does not exist");

    for (uint i = _index; i < car.vehiclePassportsSize - 1; ++i) 
    {
      car.vehiclePassports[i] = car.vehiclePassports[i + 1];
    }

    delete car.vehiclePassports[car.vehiclePassportsSize - 1];
    car.vehiclePassportsSize--;
  }


  function getAmountDuties(string calldata _VIN) 
  public 
  view 
  returns(uint) {
    string[] memory carDuties = cars[_VIN].duties;

    uint amount = 0;
    for (uint i = 0; i < carDuties.length; ++i) 
    {
      amount += dutiesList[carDuties[i]];
    }
    
    return amount;
  }

  function getCarDuties (string calldata _VIN) 
  external 
  view 
  returns(string[] memory) {
    return cars[_VIN].duties;
  }

  function getCarDutiesSize (string calldata _VIN) 
  external 
  view 
  returns(uint) {
    return cars[_VIN].duties.length;
  }

  function addCarDuty (string calldata _VIN, string calldata _duty) 
  external
  hasEditorRole("No permission to add car duty") {
    require(dutiesList[_duty] != 0, "Duty does not exists");

    cars[_VIN].duties.push(_duty);
  }


  function editDuty (string calldata name, uint amount)
  external
  hasAdminRole("No permission to add duty to the car") {
    dutiesList[name] = amount;
  }

  function removeDuty (string calldata name) 
  external 
  hasAdminRole("No permission to remove duty to the car") {
    delete dutiesList[name];
  }


  function isExistCar (string calldata _VIN) 
  external 
  view 
  returns(bool) {
    Car storage car = cars[_VIN];

    return (
      car.insurancePoliciesSize != 0 || 
      car.vehiclePassportsSize != 0 ||
      car.registrationDatesSize != 0 ||
      car.duties.length != 0
    );
  }

  function payCarDuties (string calldata _VIN) 
  external 
  payable {
    uint amount = getAmountDuties(_VIN);
    
    require(amount != 0, "Duties does not exists");
    require(msg.value >= amount, "Not enough tokens");

    uint refund = msg.value - amount;
    if (refund > 0) {
      payable(msg.sender).transfer(refund);
    }
    
    delete cars[_VIN].duties;
  }

  receive() external payable { }

  fallback() external payable { }
}
