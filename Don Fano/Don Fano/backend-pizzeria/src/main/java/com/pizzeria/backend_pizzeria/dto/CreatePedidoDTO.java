package com.pizzeria.backend_pizzeria.dto;

import lombok.Data;
import java.util.List;

@Data
public class CreatePedidoDTO {
    private Long usuarioId; 
    private List<PedidoItemDTO> items;
}