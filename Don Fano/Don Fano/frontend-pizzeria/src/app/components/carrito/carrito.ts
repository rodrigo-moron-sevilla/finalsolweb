import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { CarritoItem, CreatePedidoDTO, PedidoItemDTO } from '../../models/models';
import { CarritoService } from '../../services/carrito.service';
import { PedidoService } from '../../services/pedido.service';

@Component({
  selector: 'app-carrito',
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './carrito.html',
  styleUrl: './carrito.css'
})
export class CarritoComponent implements OnInit {
  items: CarritoItem[] = [];
  total: number = 0;
  usuarioId: number = 1; // Temporal, debería venir del servicio de autenticación

  constructor(
    private carritoService: CarritoService,
    private pedidoService: PedidoService
  ) {}

  ngOnInit(): void {
    this.cargarCarrito();
  }

  cargarCarrito(): void {
    this.carritoService.cart$.subscribe(() => {
      this.items = this.carritoService.getItems();
      this.total = this.carritoService.getTotal();
    });
  }

  aumentarCantidad(item: CarritoItem): void {
    this.carritoService.actualizarCantidad(item.producto.id!, item.cantidad + 1);
  }

  disminuirCantidad(item: CarritoItem): void {
    if (item.cantidad > 1) {
      this.carritoService.actualizarCantidad(item.producto.id!, item.cantidad - 1);
    }
  }

  actualizarCantidad(item: CarritoItem, event: any): void {
    const nuevaCantidad = parseInt(event.target.value);
    if (nuevaCantidad > 0) {
      this.carritoService.actualizarCantidad(item.producto.id!, nuevaCantidad);
    }
  }

  eliminarItem(item: CarritoItem): void {
    if (confirm(`¿Eliminar ${item.producto.nombre} del carrito?`)) {
      this.carritoService.quitarProducto(item.producto.id!);
    }
  }

  limpiarCarrito(): void {
    if (confirm('¿Estás seguro de vaciar el carrito?')) {
      this.carritoService.limpiarCarrito();
    }
  }

  realizarPedido(): void {
    if (this.items.length === 0) {
      alert('El carrito está vacío');
      return;
    }

    // Preparar el DTO según el backend
    const pedidoItems: PedidoItemDTO[] = this.items.map(item => ({
      productoId: item.producto.id!,
      cantidad: item.cantidad
    }));

    const pedidoDTO: CreatePedidoDTO = {
      usuarioId: this.usuarioId,
      items: pedidoItems
    };

    // Enviar pedido al backend
    this.pedidoService.createPedido(pedidoDTO).subscribe({
      next: (pedido) => {
        alert(`¡Pedido #${pedido.id} realizado con éxito!\nTotal: S/ ${pedido.total.toFixed(2)}`);
        this.carritoService.limpiarCarrito();
      },
      error: (err) => {
        console.error('Error al crear pedido:', err);
        alert('Error al procesar el pedido. Verifica que el backend esté corriendo.');
      }
    });
  }
}
