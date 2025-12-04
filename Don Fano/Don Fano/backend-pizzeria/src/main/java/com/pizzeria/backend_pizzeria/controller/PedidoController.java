package com.pizzeria.backend_pizzeria.controller;

import com.pizzeria.backend_pizzeria.dto.CreatePedidoDTO;
import com.pizzeria.backend_pizzeria.model.Pedido;
import com.pizzeria.backend_pizzeria.service.PedidoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pedidos")
public class PedidoController {

    @Autowired
    private PedidoService pedidoService;

    @PostMapping
    public ResponseEntity<Pedido> createPedido(@RequestBody CreatePedidoDTO pedidoDTO) {
        Pedido nuevoPedido = pedidoService.createPedido(pedidoDTO);
        return ResponseEntity.ok(nuevoPedido);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<Pedido>> getPedidosByUsuario(@PathVariable Long usuarioId) {
        List<Pedido> pedidos = pedidoService.getPedidosByUsuarioId(usuarioId);
        return ResponseEntity.ok(pedidos);
    }
}