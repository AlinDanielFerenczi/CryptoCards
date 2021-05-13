pragma solidity >=0.5.0 <0.6.0;

import "./cardownership.sol";
import "./safemath.sol";

contract CardBattle is CardOwnership {
  event BattleOver(uint playerCardId, uint enemyCardId, BattleOutcome outcome);

  using SafeMath for uint32;

  enum BattleOutcome {
    WIN,
    LOSS,
    DRAW
  }

  function ceil(uint32 a, uint32 b) internal pure returns (uint32) {
    return ((a + b - 1) / b) * b;
  }

  function battle(uint _playerCardId, uint _enemyCardId) public
    onlyOwnerOf(_playerCardId) {
    // cards alternate in attacking eachother until the health of one reaches 0
    uint32 playerTurnsToWin = ceil(cards[_enemyCardId].health, cards[_playerCardId].attack);
    uint32 enemyTurnsToWin = ceil(cards[_playerCardId].health, cards[_enemyCardId].attack);
    BattleOutcome outcome = playerTurnsToWin == enemyTurnsToWin ?
                                BattleOutcome.DRAW :
                                playerTurnsToWin < enemyTurnsToWin ?
                                BattleOutcome.WIN :
                                BattleOutcome.LOSS;
    emit BattleOver(_playerCardId, _enemyCardId, outcome);
  }
}
