pragma solidity 0.4.25;

contract StandardToken {

    /* Data structures */
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;

    /* Events */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /* Read and write storage functions */

    // Transfers sender's tokens to a given address. Returns success.
    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        else {
            return false;
        }
    }

    // Allows allowed third party to transfer tokens from one address to another. Returns success. _value Number of tokens to transfer.
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        }
        else {
            return false;
        }
    }

    // Returns number of tokens owned by given address.
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    // Sets approved amount of tokens for spender. Returns success. _value Number of approved tokens.
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /* Read storage functions */

    //Returns number of allowed tokens for given address. _owner Address of token owner. _spender Address of token spender.
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

}
