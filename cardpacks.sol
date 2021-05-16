pragma solidity >=0.5.0 <0.6.0;

import "./cards.sol";
import "./addresslist.sol";

/**
 * @dev Contract for creating and buying cards. 
 * Cards can only be added by creators, which are added by the owner of te contract.
 * The acquisition of cards is done only in packs of 1, 3, 5 or 10 cards and are received randomly
 */
contract CardPacks is CardFactory {
    using AddressList for address[];
    
    address[] public creators;
    uint[] private availableIds;
    uint private cardFee = 0.0001 ether;
    uint private randNonce = 0;
    modifier onlyCreator {
        (bool found,) = creators.find(msg.sender);
        require(found);
        _;
    }
    
    function() external payable {}
    
    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner()));
       _owner.transfer(address(this).balance);
    }
    
    function getAvailable() external view returns (uint[] memory) {
        return availableIds;
    }
    
    function setCardFee(uint _fee) external onlyOwner {
        cardFee = _fee;
    }

    function addCreator(address _creator) external onlyOwner {
      creators.add(_creator);
    }
    
    function removeCreator(address _creator) external onlyOwner {
      creators.remove(_creator);
    }
    
    function addCard(string calldata _name, string calldata _description, uint32 _mana,
                       uint32 _health, uint32 _attack, uint32 _set) external onlyCreator {
       uint id = _createCard(_name, _description, _mana, _health, _attack, _set, now);
       //we hold a list of ids for available cards
       availableIds.push(id);
    }
    
    function buyPack(uint8 cardCount) external payable {
        require(cardCount == 1 || cardCount == 3 || cardCount == 5 || cardCount == 10, "Packs contain only 1, 3, 5 or 10 cards");
        require(cardCount <= availableIds.length, "Not enough available cards");
        require(msg.value == cardCount * cardFee, "Insufficient funds");
        
        uint wonPos;
        
        for(uint i = 0; i < cardCount; i++) {
            wonPos = randMod(availableIds.length);
            
            cardToOwner[availableIds[wonPos]] = msg.sender;
            ownerCardCount[msg.sender] = ownerCardCount[msg.sender].add(1);
            
            //we delete the id from the list
            availableIds[wonPos] = availableIds[availableIds.length - 1];
            availableIds.pop();
        }
    }
    
    function randMod(uint _modulus) internal returns (uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
    }
    
}