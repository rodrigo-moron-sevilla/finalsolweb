package com.pizzeria.backend_pizzeria.dto;

import lombok.Data;

@Data
public class PedidoItemDTO {
    private Long productoId;
    private int cantidad;
}