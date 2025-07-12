# contrato-subasta
Contrato #2 realizado y subido al git
# Smart Contract Subasta

Este contrato permite realizar una subasta en la red Sepolia de Ethereum. Incluye funcionalidades como:

- Realizar ofertas que superen la anterior por al menos un 5%
- Extensión de 10 minutos si una oferta se hace en los últimos 10 minutos
- Reembolso automático a los perdedores
- Comisión del 2% para el dueño
- Verificación del contrato en Etherscan

## Dirección del contrato
[https://sepolia.etherscan.io/address/0x...](#)

## Funcionalidades

### ofertar()
Permite ofertar si se cumplen los requisitos mínimos.

### finalizarSubasta()
Finaliza la subasta y transfiere fondos al dueño.

### reembolsar()
Devuelve fondos a los perdedores.

### mostrarOfertas()
Lista todas las ofertas realizadas.

### obtenerGanador()
Muestra el ganador y el monto.

