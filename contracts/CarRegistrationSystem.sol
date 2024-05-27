// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";

contract CarRegistrationSystem is AccessControlEnumerable {
  bytes32 public constant EDITOR_ROLE = keccak256("EDITOR");

  mapping(string => Car) internal cars;
  
  string[] public dutiesList;
  mapping(string => uint) public dutiesAmount;

  constructor () {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(EDITOR_ROLE, msg.sender);
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
      amount += dutiesAmount[carDuties[i]];
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
  hasEditorRole("No permission to add duty to the car") {
    bool isExistDuty;
    (isExistDuty,) = containsString(dutiesList, _duty);
    
    require(isExistDuty, "Duty does not exists");

    string[] storage carDuties = cars[_VIN].duties;

    bool isExistCarDuty;
    (isExistCarDuty,) = containsString(carDuties, _duty);
    
    require(!isExistCarDuty, "This duty already exists");

    cars[_VIN].duties.push(_duty);
  }

  function removeCarDuty (string calldata _VIN, string calldata _duty)
  external
  hasEditorRole("No permission to remove duty to the car") {
    string[] storage carDuties = cars[_VIN].duties;
    require(carDuties.length != 0, "Duty does not exists");

    bool isExistCarDuty;
    uint index;
    (isExistCarDuty, index) = containsString(dutiesList, _duty);

    require(isExistCarDuty, "Duty does not exists");

    for (uint i = index; i < carDuties.length - 1; ++i)
    {
      carDuties[i] = carDuties[i + 1];
    }

    carDuties.pop();
  }

  function getDutiesList ()
  external
  view
  returns(string[] memory) {
    return dutiesList;
  }

  function getDutiesListLength ()
  external
  view
  returns(uint) {
    return dutiesList.length;
  }

  function addDuty (string calldata _name, uint _amount)
  external
  hasAdminRole("No permission to add duty") {
    bool isExist;
    (isExist,) = containsString(dutiesList, _name);
    
    require(!isExist, "This duty already exists");

    dutiesList.push(_name);
    dutiesAmount[_name] = _amount;
  }

  function editDuty (string calldata _name, uint _amount)
  external
  hasAdminRole("No permission to edit duty") {
    bool isExist;
    (isExist,) = containsString(dutiesList, _name);

    require(isExist, "This duty does not exist");

    dutiesAmount[_name] = _amount;
  }

  function removeDuty (string calldata _name) 
  external 
  hasAdminRole("No permission to remove duty") {
    bool isExist;
    uint index;
    (isExist, index) = containsString(dutiesList, _name);

    require(isExist, "This duty does not exist");

    for (uint i = index; i < dutiesList.length - 1; ++i)
    {
      dutiesList[i] = dutiesList[i + 1];
    }

    dutiesList.pop();
    delete dutiesAmount[_name];
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

  function containsString(string[] memory _array, string calldata _name)
  private
  pure
  returns(bool, uint) {
    for (uint i = 0; i < _array.length; ++i)
    {
      if (toEqualString(_name, _array[i])) {
        return (true, i);
      }
    }

    return (false, _array.length);
  }

  function toEqualString (string memory s1, string memory s2)
  public
  pure
  returns(bool) {
    return (keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2)));
  }

  function getBalance ()
  external
  view
  returns(uint) {
    return address(this).balance;
  }

  function transfer(address _address, uint _amount)
  external
  hasAdminRole("No permission to transfer") {
    require(address(this).balance <= _amount, "The balance has few funds");

    payable(_address).transfer(_amount);
  }

  receive() external payable { }

  fallback() external payable { }
}
