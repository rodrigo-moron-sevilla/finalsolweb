import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Producto, Categoria } from '../../models/models';
import { ProductoService } from '../../services/producto.service';
import { CategoriaService } from '../../services/categoria.service';
import { CarritoService } from '../../services/carrito.service';

declare var bootstrap: any;

@Component({
  selector: 'app-menu',
  imports: [CommonModule],
  templateUrl: './menu.html',
  styleUrl: './menu.css'
})
export class MenuComponent implements OnInit {
  productos: Producto[] = [];
  productosFiltrados: Producto[] = [];
  categorias: Categoria[] = [];
  categoriaSeleccionada: number = 0;
  productoSeleccionado: Producto | null = null;
  cargando: boolean = true;
  private modal: any;

  constructor(
    private productoService: ProductoService,
    private categoriaService: CategoriaService,
    private carritoService: CarritoService
  ) {}

  ngOnInit(): void {
    this.cargarCategorias();
    this.cargarProductos();
  }

  cargarCategorias(): void {
    this.categoriaService.getAllCategorias().subscribe({
      next: (data) => this.categorias = data,
      error: (err) => console.error('Error al cargar categorías:', err)
    });
  }

  cargarProductos(): void {
    this.productoService.getAllProductos().subscribe({
      next: (data) => {
        console.log('Productos cargados:', data);
        this.productos = data;
        this.filtrarPorCategoria(this.categoriaSeleccionada);
        this.cargando = false;
      },
      error: (err) => {
        console.error('Error al cargar productos:', err);
        this.cargando = false;
      }
    });
  }

  filtrarPorCategoria(categoriaId: number): void {
    this.categoriaSeleccionada = categoriaId;
    if (categoriaId === 0) {
      this.productosFiltrados = this.productos;
    } else {
      this.productosFiltrados = this.productos.filter(p => p.categoriaId === categoriaId);
    }
  }

  agregarAlCarrito(producto: Producto): void {
    this.carritoService.agregarProducto(producto, 1);
    // Mostrar mensaje de éxito (opcional)
    alert(`${producto.nombre} agregado al carrito`);
  }

  verDetalle(producto: Producto): void {
    this.productoSeleccionado = producto;
    this.modal = new bootstrap.Modal(document.getElementById('productoModal'));
    this.modal.show();
  }

  agregarAlCarritoYCerrar(): void {
    if (this.productoSeleccionado) {
      this.agregarAlCarrito(this.productoSeleccionado);
      this.modal.hide();
    }
  }

  getNombreCategoria(categoriaId: number): string {
    const categoria = this.categorias.find(c => c.id === categoriaId);
    return categoria ? categoria.nombre : 'Sin categoría';
  }
}
