import { Injectable } from '@angular/core';
import { CarritoItem, Producto } from '../models/models';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CarritoService {
  private items: CarritoItem[] = [];
  private cartSubject = new BehaviorSubject<CarritoItem[]>([]);
  public cart$: Observable<CarritoItem[]> = this.cartSubject.asObservable();

  constructor() {
    // Cargar carrito desde localStorage
    const savedCart = localStorage.getItem('carrito');
    if (savedCart) {
      this.items = JSON.parse(savedCart);
      this.cartSubject.next(this.items);
    }
  }

  // Agregar producto al carrito
  agregarProducto(producto: Producto, cantidad: number = 1): void {
    const existingItem = this.items.find(item => item.producto.id === producto.id);
    
    if (existingItem) {
      existingItem.cantidad += cantidad;
      existingItem.subtotal = existingItem.cantidad * existingItem.producto.precio;
    } else {
      this.items.push({
        producto: producto,
        cantidad: cantidad,
        subtotal: producto.precio * cantidad
      });
    }
    
    this.actualizarCarrito();
  }

  // Quitar producto del carrito
  quitarProducto(productoId: number): void {
    this.items = this.items.filter(item => item.producto.id !== productoId);
    this.actualizarCarrito();
  }

  // Actualizar cantidad
  actualizarCantidad(productoId: number, cantidad: number): void {
    const item = this.items.find(item => item.producto.id === productoId);
    if (item) {
      item.cantidad = cantidad;
      item.subtotal = item.cantidad * item.producto.precio;
      this.actualizarCarrito();
    }
  }

  // Obtener items del carrito
  getItems(): CarritoItem[] {
    return this.items;
  }

  // Calcular total
  getTotal(): number {
    return this.items.reduce((total, item) => total + item.subtotal, 0);
  }

  // Obtener cantidad de items
  getCantidadTotal(): number {
    return this.items.reduce((total, item) => total + item.cantidad, 0);
  }

  // Limpiar carrito
  limpiarCarrito(): void {
    this.items = [];
    this.actualizarCarrito();
  }

  // Actualizar y guardar en localStorage
  private actualizarCarrito(): void {
    localStorage.setItem('carrito', JSON.stringify(this.items));
    this.cartSubject.next(this.items);
  }
}
