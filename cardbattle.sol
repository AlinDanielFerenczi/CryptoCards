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

  function _ceil(uint32 a, uint32 b) public pure returns (uint32) {
    return b == 0 ?
        0 :
        (a / b) + (a % b == 0 ? 0 : 1);
  }

  function battle(uint _playerCardId, uint _enemyCardId) external
    onlyOwnerOf(_playerCardId) {
    // cards alternate in attacking eachother until the health of one reaches 0
    uint32 playerTurnsToWin = _ceil(cards[_enemyCardId].health, cards[_playerCardId].attack);
    uint32 enemyTurnsToWin = _ceil(cards[_playerCardId].health, cards[_enemyCardId].attack);
    BattleOutcome outcome = playerTurnsToWin == enemyTurnsToWin ?
                                BattleOutcome.DRAW :
                                playerTurnsToWin < enemyTurnsToWin && playerTurnsToWin != 0 || enemyTurnsToWin == 0 ?
                                BattleOutcome.WIN :
                                BattleOutcome.LOSS;
    emit BattleOver(_playerCardId, _enemyCardId, outcome);
  }
}
