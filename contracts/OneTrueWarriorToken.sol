// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract OneTrueWarriorToken is ERC721, Ownable  {
    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    //variables
    uint256 counter;
    uint256 fee = 0.0001 ether;

    struct OneTrueWarrior {
        string name;
        uint256 id;
        uint256 hashNumber;
        uint8 level;
        uint8 rarity;
        uint8 attack;
        uint8 defense;
    }

    OneTrueWarrior[] public oneTruWarriors;

    //event
    event NewToken(address indexed owner, uint256 id, uint256 hashNumber);



    //Generator Function
    function generateRandomStatistic(uint256 _mod) internal view returns(uint256) {
        uint256 randomData = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        return randomData % _mod;
    }

    //Creation function
    function createOnlyTrueWarrior(string memory _name) internal { 
        uint8 randRarity = uint8(generateRandomStatistic(20));
        uint8 randAttack = uint8(generateRandomStatistic(100));
        uint8 randDefense = uint8(generateRandomStatistic(100));
        uint256 randHashNumber = uint256(generateRandomStatistic(10**16));
        //Token struct properties
        OneTrueWarrior memory newOneTrueWarrior = OneTrueWarrior(_name, counter, randHashNumber, 1, randRarity, randAttack, randDefense);
        oneTruWarriors.push(newOneTrueWarrior);
        _safeMint(msg.sender,counter);
        emit NewToken(msg.sender, counter, randHashNumber);
        counter++;
    }

    function createRandomToken(string memory _name) public payable {
        require(msg.value >= fee);
        createOnlyTrueWarrior(_name);   
    }


    //Fee functions
    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    //Withdraw
    function withdraw() external payable onlyOwner {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }


    //Getters
    function getToken() public view returns (OneTrueWarrior[] memory) {
        return oneTruWarriors;
    }

    function getOwner(address _owner) public view returns(OneTrueWarrior[] memory) {
        OneTrueWarrior[] memory result = new OneTrueWarrior[](balanceOf(_owner));
        uint256 Counter = 0;
        for (uint256 i = 0; i < oneTruWarriors.length; i++) {
            if (ownerOf(i) == _owner) {
                result[Counter] = oneTruWarriors[i];
                Counter++;
            }
        }
        return result;
    }

    //Actions
    function levelUp(uint256 _warriorId) public  {
        require(ownerOf(_warriorId) == msg.sender);
        OneTrueWarrior storage onetruewarrior = oneTruWarriors[_warriorId];
        onetruewarrior.level++;
    }

}