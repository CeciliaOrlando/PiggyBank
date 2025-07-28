// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol"; // Para operaciones matemáticas seguras
import "@openzeppelin/contracts/access/Ownable.sol"; // Para un control de propiedad robusto


contract SecurePiggyBank is Ownable { // Hereda de Ownable para gestionar el propietario y el acceso.
    using SafeMath for uint256; // Habilita SafeMath para operaciones con uint256

    // Mapeo para mantener un registro de los saldos depositados por cada dirección. Esto es útil si quieres permitir retiros parciales por usuario, pero para una alcancía simple que solo el dueño puede vaciar, el balance del contrato es suficiente. 
    mapping(address => uint256) public deposits;

    // Evento que se emite cuando se deposita Ether.
    event EtherDeposited(address indexed depositor, uint256 amount, uint256 contractBalance);

    // Evento que se emite cuando se retira Ether (solo por el propietario).
    event EtherWithdrawn(address indexed to, uint256 amount, uint256 contractBalance);

    constructor() {
        // El constructor de Ownable ya establece `owner = msg.sender;` No necesitamos `owner = msg.sender;` aquí si heredamos de Ownable.
    }

    
    function deposit() public payable {
        require(msg.value > 0, "No se puede depositar 0 ETH."); // Previene depositar 0 ETH

        // Opcional: Si quisiéramos registrar depósitos individuales por usuario
        // deposits[msg.sender] = deposits[msg.sender].add(msg.value);

        emit EtherDeposited(msg.sender, msg.value, address(this).balance);
    }

  
    function withdrawAll() public onlyOwner { // Vulnerabilidad Corregida: Solo el propietario puede llamar
        uint256 amountToWithdraw = address(this).balance; // Guarda el balance del contrato ANTES de enviar

        require(amountToWithdraw > 0, "No hay fondos para retirar."); // Previene retiros de 0 ETH


        (bool success, ) = payable(msg.sender).call{value: amountToWithdraw}("");
        require(success, "Fallo al enviar Ether."); // Confirma que el envío fue exitoso

        emit EtherWithdrawn(msg.sender, amountToWithdraw, address(this).balance);
    }

    // Opcional: Si se implementara `deposits` por usuario, se añadiría una función `withdraw` para cada usuario.
    // function withdraw() public { ... } // Función de retiro para el usuario, no para el propietario.

    /**
     * @dev Función de fallback para recibir Ether enviado directamente al contrato.
     * Simplemente llama a la función deposit().
     */
    receive() external payable {
        deposit();
    }
}
