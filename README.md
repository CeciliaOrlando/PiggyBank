
Auditoría y Corrección de Vulnerabilidad en Contrato de Bóveda
Este repositorio contiene un ejemplo práctico de auditoría de seguridad para un contrato inteligente de Ethereum, demostrando una vulnerabilidad común y su corrección. Incluye la versión vulnerable, la corregida y segura, y un contrato de ataque diseñado para explotar la vulnerabilidad original.

🚀 Contenido del Repositorio
En este repositorio encontrarás los siguientes archivos clave:

VulnerablePiggyBank.sol
Este es el contrato inteligente original que contiene una vulnerabilidad crítica de control de acceso en su función de retiro. Su propósito es ilustrar un error de seguridad común que podría llevar a la pérdida de todos los fondos del contrato por parte de un atacante.

SecurePiggyBank.sol
Esta es la versión corregida y auditada del contrato de la bóveda. Implementa las mejores prácticas de seguridad en Solidity, incluyendo:

Control de Acceso: Utiliza el contrato Ownable de OpenZeppelin para restringir la función de retiro solo al propietario del contrato.

Matemáticas Seguras: Incorpora SafeMath de OpenZeppelin para prevenir desbordamientos y subdesbordamientos.

Patrón Checks-Effects-Interactions: Sigue esta recomendación de seguridad para prevenir ataques de reentrada durante las transferencias de Ether.

Validaciones Robusta: Añade require() para asegurar que las operaciones (depósitos/retiros) cumplan con condiciones válidas (ej., no depositar 0 ETH).

AttackPiggyBank.sol
Este es un contrato inteligente diseñado para demostrar y explotar la vulnerabilidad presente en el contrato VulnerablePiggyBank.sol original. Al desplegar este contrato y llamar a su función attack(), se intentará vaciar el Ether del VulnerablePiggyBank.

⚠️ ¡ADVERTENCIA! Este contrato de ataque solo es funcional contra la versión vulnerable (VulnerablePiggyBank.sol). No tendrá éxito contra el contrato SecurePiggyBank.sol debido a las correcciones de seguridad implementadas.

🔍 Vulnerabilidad Explicada
La principal vulnerabilidad en VulnerablePiggyBank.sol reside en la función withdraw():

Solidity

function withdraw() public { payable(msg.sender).transfer(address(this).balance); }
Problema: La función withdraw() es public. Esto significa que cualquier dirección externa puede llamarla y retirar todo el Ether almacenado en el contrato. No hay ninguna verificación para asegurar que solo el propietario o una parte autorizada pueda realizar el retiro. Esto es una vulnerabilidad de acceso no autorizado.

✅ Correcciones Implementadas
En SecurePiggyBank.sol, se implementaron las siguientes mejoras y correcciones:

Control de Acceso con Ownable:

SecurePiggyBank ahora hereda de Ownable de OpenZeppelin.

La función de retiro se renombró a withdrawAll() y se marcó con el modificador onlyOwner, asegurando que solo el propietario original del contrato pueda vaciar los fondos.

Defensa contra Reentrada (Best Practice):

Se utiliza el patrón Checks-Effects-Interactions para estructurar la función de retiro, mitigando el riesgo de ataques de reentrada (incluso si transfer() ya ofrece cierta protección).

El envío de Ether se realiza con call{value: ...} y se verifica su éxito, que es el método recomendado y más robusto en Solidity moderno.

Validaciones de Entrada:

Se añadió require(msg.value > 0, "No se puede depositar 0 ETH."); en deposit() para evitar transacciones ineficientes.

Se añadió require(amountToWithdraw > 0, "No hay fondos para retirar."); en withdrawAll() para evitar retiros de 0 ETH.

🛠️ Cómo Probar la Vulnerabilidad y la Corrección (Usando Remix IDE)
Sigue estos pasos para demostrar la vulnerabilidad y luego verificar la solución:

Abrir en Remix IDE: Ve a remix.ethereum.org.

Preparar los Contratos:

Crea un nuevo archivo (ej., PiggyBank.sol) y pega el código de VulnerablePiggyBank.sol.

Crea otro archivo (ej., Attack.sol) y pega el código de AttackPiggyBank.sol.

Crea un tercer archivo (ej., SecureVault.sol) y pega el código de SecurePiggyBank.sol (recuerda que este requiere la importación de OpenZeppelin Contracts, que Remix maneja automáticamente si la versión de Solidity es compatible).

Compilar los Contratos:

Ve a la pestaña "Solidity Compiler" (icono del compilador).

Asegúrate de que la versión del compilador sea 0.8.0 o superior.

Compila los tres contratos.

Demostrar la Vulnerabilidad (VulnerablePiggyBank y AttackPiggyBank):

Ve a la pestaña "Deploy & Run Transactions".

Paso A: Financiar el Contrato Vulnerable:

En "Environment", selecciona Remix VM (Shanghai).

En "Contract", elige VulnerablePiggyBank.

En "Value", introduce una cantidad (ej., 5 ETH) y haz clic en "Deploy".

Una vez desplegado, selecciona una cuenta DIFERENTE de la que usaste para desplegar el VulnerablePiggyBank.

En "Value", introduce 1 ETH y haz clic en el botón deposit de la instancia de VulnerablePiggyBank desplegada (esto simula un depósito de un usuario real).

Verifica el balance del VulnerablePiggyBank (copia su dirección y pégala en getBalance de un contrato nuevo, o en etherscan si fuera una testnet).

Paso B: Ejecutar el Ataque:

Asegúrate de tener la cuenta del atacante seleccionada (la que usarás para desplegar AttackPiggyBank).

En "Contract", elige AttackPiggyBank.

En el campo al lado del botón "Deploy", pega la dirección del VulnerablePiggyBank que acabas de desplegar.

Haz clic en "Deploy".

Una vez que el AttackPiggyBank esté desplegado, haz clic en su función attack().

Observa la consola de Remix: La transacción debería ser exitosa.

Verifica el balance del VulnerablePiggyBank original: Debería ser 0 ETH.

Verifica el balance de la cuenta que desplegó AttackPiggyBank: Debería haber recibido el Ether robado. ¡La vulnerabilidad ha sido explotada!

Verificar la Corrección (SecurePiggyBank):

Ve a la pestaña "Deploy & Run Transactions".

Paso A: Financiar el Contrato Seguro:

En "Environment", selecciona Remix VM (Shanghai).

En "Contract", elige SecurePiggyBank.

En "Value", introduce una cantidad (ej., 5 ETH) y haz clic en "Deploy". Esta cuenta que despliega es ahora el owner.

Selecciona una cuenta DIFERENTE del owner.

En "Value", introduce 1 ETH y haz clic en el botón deposit de la instancia de SecurePiggyBank desplegada (simulando el depósito de un usuario).

Paso B: Intentar el Ataque (que fallará):

Asegúrate de tener la cuenta no-propietario seleccionada (la que usaste para el depósito de prueba).

Intenta llamar a la función withdrawAll() del SecurePiggyBank desplegado.

Observa la consola de Remix: La transacción debería fallar con el mensaje de error "Solo el propietario puede llamar a esta funcion.", confirmando que la vulnerabilidad de acceso ha sido corregida.

Solo la cuenta del owner (la que desplegó el SecurePiggyBank) podrá llamar a withdrawAll() con éxito.

🔒 Licencia
Este proyecto está bajo la licencia MIT. Consulta el archivo LICENSE para más detalles.
