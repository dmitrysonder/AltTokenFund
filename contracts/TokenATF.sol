pragma solidity 0.4.25;

import "./StandardToken.sol";

contract AltTokenFund is StandardToken {

    /* External contracts */

    address public emissionContractAddress = 0x0;

    //Token meta data
    string constant public name = "Alt Token Fund";
    string constant public symbol = "ATF";
    uint8 constant public decimals = 8;

    /* Storage */
    address public owner = 0x0;
    bool public emissionEnabled = true;
    bool transfersEnabled = true;

    /* Modifiers */

    modifier isCrowdfundingContract() {
        // Only emission address to do this action
        if (msg.sender != emissionContractAddress) {
            revert();
        }
        _;
    }

    modifier onlyOwner() {
        // Only owner is allowed to do this action.
        if (msg.sender != owner) {
            revert();
        }
        _;
    }

    /* Events */

    event Withdrawal(address indexed owner, uint256 value);
    event Issuance(address indexed _for, uint256 value);

    /* Contract Functions */

    // TokenFund emission function. _for is Address of receiver, tokenCount is Number of tokens to issue.
    function issueTokens(address _for, uint tokenCount)
        external
        isCrowdfundingContract
        returns (bool)
    {
        if (emissionEnabled == false) {
            revert();
        }

        balances[_for] += tokenCount;
        totalSupply += tokenCount;
        emit Issuance(_for, tokenCount);
        return true;
    }

    // Withdraws tokens for msg.sender.
    function withdrawTokens(uint tokenCount)
        public
        returns (bool)
    {
        uint balance = balances[msg.sender];
        if (balance < tokenCount) {
            revert();
            return false;
        }
        balances[msg.sender] -= tokenCount;
        totalSupply -= tokenCount;
        emit Withdrawal(msg.sender, tokenCount);
        return true;
    }

    // Function to change address that is allowed to do emission.
    function changeEmissionContractAddress(address newAddress)
        external
        onlyOwner
    {
        emissionContractAddress = newAddress;
    }

    // Function that enables/disables transfers of token, value is true/false
    function enableTransfers(bool value)
        external
        onlyOwner
    {
        transfersEnabled = value;
    }

    // Function that enables/disables token emission.
    function enableEmission(bool value)
        external
        onlyOwner
    {
        emissionEnabled = value;
    }

    /* Overriding ERC20 standard token functions to support transfer lock */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (transfersEnabled == true) {
            return super.transfer(_to, _value);
        }
        return false;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (transfersEnabled == true) {
            return super.transferFrom(_from, _to, _value);
        }
        return false;
    }


    // Contract constructor function sets initial token balances. _owner Address of the owner of AltTokenFund.
    constructor (address _owner) public
    {
        totalSupply = 0;
        owner = _owner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
