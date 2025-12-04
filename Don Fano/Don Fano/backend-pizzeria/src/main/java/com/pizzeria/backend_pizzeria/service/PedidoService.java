package com.pizzeria.backend_pizzeria.service;

import com.pizzeria.backend_pizzeria.dto.CreatePedidoDTO;
import com.pizzeria.backend_pizzeria.dto.PedidoItemDTO;
import com.pizzeria.backend_pizzeria.model.*;
import com.pizzeria.backend_pizzeria.repository.PedidoRepository;
import com.pizzeria.backend_pizzeria.repository.ProductoRepository;
import com.pizzeria.backend_pizzeria.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class PedidoService {

    @Autowired
    private PedidoRepository pedidoRepository;
    @Autowired
    private UsuarioRepository usuarioRepository;
    @Autowired
    private ProductoRepository productoRepository;

    public List<Pedido> getPedidosByUsuarioId(Long usuarioId) {
        return pedidoRepository.findByUsuarioId(usuarioId);
    }

    @Transactional
    public Pedido createPedido(CreatePedidoDTO pedidoDTO) {
        Usuario usuario = usuarioRepository.findById(pedidoDTO.getUsuarioId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Pedido pedido = new Pedido();
        pedido.setUsuario(usuario);
        pedido.setFecha(LocalDateTime.now());
        pedido.setEstado(EstadoPedido.PENDIENTE);

        List<PedidoDetalle> detalles = new ArrayList<>();
        BigDecimal totalPedido = BigDecimal.ZERO;

        for (PedidoItemDTO itemDTO : pedidoDTO.getItems()) {
            Producto producto = productoRepository.findById(itemDTO.getProductoId())
                    .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

            PedidoDetalle detalle = new PedidoDetalle();
            detalle.setPedido(pedido);
            detalle.setProducto(producto);
            detalle.setCantidad(itemDTO.getCantidad());
            BigDecimal subtotal = producto.getPrecio().multiply(BigDecimal.valueOf(itemDTO.getCantidad()));
            detalle.setSubtotal(subtotal);
            detalles.add(detalle);

            totalPedido = totalPedido.add(subtotal);
        }

        pedido.setTotal(totalPedido);
        pedido.setDetalles(detalles);

        return pedidoRepository.save(pedido);
    }
}