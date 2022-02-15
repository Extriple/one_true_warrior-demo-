const OneTrueWarriorToken = artifacts.require("OneTrueWarriorToken");

module.exports = function (deployer) {
  deployer.deploy(OneTrueWarriorToken,"OneTrueWarrior", "OTW");
};

//Przed migracja nalezy sprawdzic czy nazwa contractu jest poprawnie wpisana w plikach js, ktore odnosza sie do migracji 
