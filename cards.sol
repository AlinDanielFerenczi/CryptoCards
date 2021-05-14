pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";
import "./safemath.sol";

contract CardFactory is Ownable {
  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewCard(uint cardId, string name, string description, uint32 mana,
                uint32 health, uint32 attack, uint32 set, uint256 releaseDate);

  struct Card {
    string name;
    string description;
    uint32 mana;
    uint32 health;
    uint32 attack;
    uint32 set;
    uint256 releaseDate;
  }

  Card[] public cards;

  mapping (uint => address) public cardToOwner;
  mapping (address => uint) ownerCardCount;

  modifier hasValidHealth(uint32 _health) {
      require(_health > 0);
      _;
  }

  function _createCard(string memory _name, string memory _description, uint32 _mana,
                       uint32 _health, uint32 _attack, uint32 _set, uint256 _releaseDate) internal
    hasValidHealth(_health)
    returns (uint) {
    uint id = cards.push(Card(_name, _description, _mana, _health, _attack, _set, _releaseDate)) - 1;
    emit NewCard(id, _name, _description, _mana, _health, _attack, _set, _releaseDate);
    return id;
  }
}
