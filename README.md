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


📝 Nombre del contrato: Subasta
🎯 Propósito del contrato

Este contrato permite realizar una subasta pública descentralizada, donde múltiples usuarios pueden pujar por un bien durante un tiempo determinado. Al finalizar la subasta, el mejor postor gana, se registra la comisión para el dueño, y los demás ofertantes pueden retirar sus fondos.


🧱 Componentes principales
🧑‍💼 1. Propiedades del contrato
address public dueno: dirección del creador del contrato (el dueño de la subasta).

uint public finSubasta: marca de tiempo (timestamp) en la que termina la subasta.

uint public duracion: duración de la subasta en minutos.

bool public activa: bandera para indicar si la subasta sigue activa.

uint public comision = 2: porcentaje de comisión que el dueño cobra del valor final (2%).

📦 2. Estructura Oferta
Representa una oferta en la subasta:

solidity
Copiar
Editar
struct Oferta {
    address ofertante;
    uint monto;
}
Se almacena la mejor oferta y un historial de todas las ofertas.

⚙️ Funciones y lógica

🏗️ constructor(uint _duracionMinutos)

Inicializa la subasta.

Calcula finSubasta en base al tiempo actual más la duración.

Establece al creador como dueno.

Activa la subasta.

📤 function ofertar() external payable


Permite a los usuarios hacer una oferta:

Verifica que la subasta esté activa y dentro del tiempo permitido.

Exige que la nueva oferta supere la anterior por al menos un 5%.

Si se hace una oferta en los últimos 10 minutos, se extiende el tiempo de subasta.

Si existe una mejor oferta anterior, se guarda en un mapa de fondos reembolsables.

Registra y emite el evento NuevaOferta.

⏹️ function finalizarSubasta() external soloDueno

Función que puede llamar solo el dueño:

Verifica que el tiempo de subasta haya finalizado.

Marca la subasta como finalizada (activa = false).

Calcula la comisión del dueño (2%) y transfiere el restante.

Emite el evento SubastaFinalizada.

💸 function reembolsar() external

Permite a los ofertantes no ganadores recuperar su dinero:

Verifica que el ofertante tenga fondos reembolsables.

Transfiere esos fondos y los pone en cero.

📜 function mostrarOfertas() external view returns (Oferta[] memory)
Devuelve el historial completo de ofertas en orden de llegada.

🥇 function obtenerGanador() external view returns (address, uint)
Solo puede llamarse una vez que la subasta ha terminado.

Devuelve el ganador y el monto de la mejor oferta.

📢 Eventos
NuevaOferta(address ofertante, uint monto): emitido cada vez que alguien hace una oferta válida.

SubastaFinalizada(address ganador, uint montoGanador): emitido al finalizar la subasta con el ganador.

🔐 Modificadores
soloMientrasActiva: asegura que ciertas funciones solo se ejecuten mientras la subasta está activa.

soloDueno: restringe funciones a que solo las pueda ejecutar el dueño de la subasta.

✅ Resumen del flujo
🛠️ El dueño despliega el contrato indicando duración (ej. 10 minutos).

🧑 Usuarios hacen ofertas superando la anterior en al menos 5%.

⏳ Si ofertan cerca del final, se extiende 10 minutos más.

💥 El dueño finaliza la subasta, cobra su parte y el ganador queda registrado.

🔁 Los ofertantes perdedores pueden retirar su dinero.

🚨 Ventajas del contrato
Transparente y sin intermediarios.

Reembolsos automáticos.

Protección contra sniping (extensión de tiempo al final).

Control exclusivo del dueño sobre el cierre.
