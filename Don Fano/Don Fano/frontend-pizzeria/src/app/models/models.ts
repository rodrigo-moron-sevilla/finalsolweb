// Modelo Usuario (tabla: usuarios)
export interface Usuario {
  id?: number;
  nombre: string;
  apellido: string;
  email: string;
  password?: string;
  rol: 'CLIENTE' | 'ADMIN';
}

// Modelo Categoria (tabla: categorias)
export interface Categoria {
  id?: number;
  nombre: string;
}

// Modelo Producto (tabla: productos)
export interface Producto {
  id?: number;
  nombre: string;
  descripcion: string;
  precio: number;
  categoriaId: number;
  categoria?: Categoria;
}

// Modelo Pedido (tabla: pedidos)
export interface Pedido {
  id?: number;
  usuarioId: number;
  fecha: Date | string;
  total: number;
  estado: 'PENDIENTE' | 'ENTREGADO' | 'CANCELADO';
  usuario?: Usuario;
  detalles?: PedidoDetalle[];
}

// Modelo PedidoDetalle (tabla: pedido_detalle)
export interface PedidoDetalle {
  id?: number;
  pedidoId: number;
  productoId: number;
  cantidad: number;
  subtotal: number;
  producto?: Producto;
}

// DTOs para crear pedidos
export interface CreatePedidoDTO {
  usuarioId: number;
  items: PedidoItemDTO[];
}

export interface PedidoItemDTO {
  productoId: number;
  cantidad: number;
}

// DTO para login
export interface LoginRequest {
  email: string;
  password: string;
}

export interface AuthResponse {
  token: string;
  usuario: Usuario;
}

// Item del carrito (para el frontend)
export interface CarritoItem {
  producto: Producto;
  cantidad: number;
  subtotal: number;
}
