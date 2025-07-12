// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Subasta {
    address public dueno;
    uint public finSubasta;
    uint public duracion;
    bool public activa;
    uint public comision = 2; // 2%

    struct Oferta {
        address ofertante;
        uint monto;
    }

    Oferta public mejorOferta;
    Oferta[] public historialOfertas;
    mapping(address => uint) public fondos;

    event NuevaOferta(address indexed ofertante, uint monto);
    event SubastaFinalizada(address ganador, uint montoGanador);

    modifier soloMientrasActiva() {
        require(activa, "La subasta ha finalizado");
        _;
    }

    modifier soloDueno() {
        require(msg.sender == dueno, "Solo el dueno puede hacer esto");
        _;
    }

    constructor(uint _duracionMinutos) {
        dueno = msg.sender;
        duracion = _duracionMinutos * 1 minutes;
        finSubasta = block.timestamp + duracion;
        activa = true;
    }

    function ofertar() external payable soloMientrasActiva {
        require(block.timestamp < finSubasta, "Subasta expirada");

        uint ofertaMinima = mejorOferta.monto + (mejorOferta.monto * 5) / 100;
        require(msg.value >= ofertaMinima, "Debes superar la oferta por al menos 5%");

        // Extiende la subasta si faltan 10 minutos o menos
        if (block.timestamp >= finSubasta - 10 minutes) {
            finSubasta += 10 minutes;
        }

        // Almacenar depósito anterior para reembolso
        if (mejorOferta.monto > 0) {
            fondos[mejorOferta.ofertante] += mejorOferta.monto;
        }

        mejorOferta = Oferta(msg.sender, msg.value);
        historialOfertas.push(mejorOferta);

        emit NuevaOferta(msg.sender, msg.value);
    }

    function finalizarSubasta() external soloDueno {
        require(activa, "La subasta ya ha sido finalizada");
        require(block.timestamp >= finSubasta, "La subasta aun esta activa");

        activa = false;

        uint comisionMonto = (mejorOferta.monto * comision) / 100;
        uint montoDueno = mejorOferta.monto - comisionMonto;

        payable(dueno).transfer(montoDueno);

        emit SubastaFinalizada(mejorOferta.ofertante, mejorOferta.monto);
    }

    function reembolsar() external {
        require(!activa, "La subasta aun esta activa");

        uint monto = fondos[msg.sender];
        require(monto > 0, "No hay fondos para reembolsar");

        fondos[msg.sender] = 0;
        payable(msg.sender).transfer(monto);
    }

    function mostrarOfertas() external view returns (Oferta[] memory) {
        return historialOfertas;
    }

    function obtenerGanador() external view returns (address, uint) {
        require(!activa, "La subasta aun esta activa");
        return (mejorOferta.ofertante, mejorOferta.monto);
    }
}
