const jsonServer = require("json-server");

const contractArtifact = require("../ignition/deployments/chain-31337/artifacts/CarRegistrationSystem#CarRegistrationSystem.json");
const contractDeployedAddress = require("../ignition/deployments/chain-31337/deployed_addresses.json")


const config = {
  contract: {
    address: contractDeployedAddress["CarRegistrationSystem#CarRegistrationSystem"],
    abi: contractArtifact.abi
  }
}

const server = jsonServer.create()
const router = jsonServer.router(config)
const middlewares = jsonServer.defaults()

server.use(middlewares)
server.use(router)
server.listen(3000, function () {
  console.log('JSON Server is running')
})