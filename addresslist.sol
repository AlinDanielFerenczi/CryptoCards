pragma solidity >=0.5.0 <0.6.0;


/**
 * @dev Wrapper library for address[] 
 *
 */
library AddressList {
    function add(address[] storage list, address _value) internal returns (uint) {
        return list.push(_value);
    }
    
    function find(address[] storage list, address _value) internal view returns (bool, uint) {
        uint index = 0;
        for(; index < list.length && list[index] != _value; index++) {}
        return index == list.length ? 
            (false, 0) :
            (true, index);
    }
    
    function remove(address[] storage list, address _value) internal {
        (bool found, uint indexToRemove) = find(list, _value);
        require(found);
        
        list[indexToRemove] = list[list.length - 1];
        list.pop();
    }
    
    function get(address[] storage list, uint _index) internal view returns (address) {
        require(_index >= 0 && _index < list.length);
        return list[_index];
    }
}