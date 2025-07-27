// SPDX-License-Identifier: MIT
pragma MIT solidity ^0.8.0;

contrato VulnerablePiggyBank {
    dirección pública propietario;
    constructor() { propietario = msg.sender }
    función deposit() público pagar {}
    función retirar() público { pagar(msg.sender).transfer(dirección(this).balance); }
    función ataque() público { }
}
