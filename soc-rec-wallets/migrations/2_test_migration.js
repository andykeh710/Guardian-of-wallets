const Guardianwallet = artifacts.require("Guardianwallet");

module.exports = function (deployer) {
  deployer.deploy(Guardianwallet);
};
