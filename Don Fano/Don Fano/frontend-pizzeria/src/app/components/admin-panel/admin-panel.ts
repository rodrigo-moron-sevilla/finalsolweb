import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Producto, Categoria } from '../../models/models';
import { ProductoService } from '../../services/producto.service';
import { CategoriaService } from '../../services/categoria.service';

declare var bootstrap: any;

@Component({
  selector: 'app-admin-panel',
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-panel.html',
  styleUrl: './admin-panel.css'
})
export class AdminPanelComponent implements OnInit {
  productos: Producto[] = [];
  productosFiltrados: Producto[] = [];
  categorias: Categoria[] = [];
  categoriaSeleccionada: number = 0;
  productoSeleccionado: Producto | null = null;
  modoEdicion: boolean = false;
  cargando: boolean = true;

  // Formulario
  productoForm: Producto = {
    nombre: '',
    descripcion: '',
    precio: 0,
    categoriaId: 1
  };

  constructor(
    private productoService: ProductoService,
    private categoriaService: CategoriaService
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
        console.log('Productos cargados en admin:', data);
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

  abrirModalNuevo(): void {
    this.modoEdicion = false;
    this.productoForm = {
      nombre: '',
      descripcion: '',
      precio: 0,
      categoriaId: 1
    };
    const modal = new bootstrap.Modal(document.getElementById('productoModal'));
    modal.show();
  }

  abrirModalEditar(producto: Producto): void {
    this.modoEdicion = true;
    this.productoForm = { ...producto };
    const modal = new bootstrap.Modal(document.getElementById('productoModal'));
    modal.show();
  }

  guardarProducto(): void {
    if (this.modoEdicion) {
      // Actualizar producto existente
      this.productoService.updateProducto(this.productoForm.id!, this.productoForm).subscribe({
        next: () => {
          alert('Producto actualizado exitosamente');
          this.cargarProductos();
          this.cerrarModal();
        },
        error: (err) => {
          console.error('Error al actualizar:', err);
          alert('Error al actualizar el producto. Verifica que el backend esté corriendo.');
        }
      });
    } else {
      // Crear nuevo producto
      this.productoService.createProducto(this.productoForm).subscribe({
        next: () => {
          alert('Producto creado exitosamente');
          this.cargarProductos();
          this.cerrarModal();
        },
        error: (err) => {
          console.error('Error al crear:', err);
          alert('Error al crear el producto. Verifica que el backend esté corriendo.');
        }
      });
    }
  }

  eliminarProducto(producto: Producto): void {
    if (confirm(`¿Estás seguro de eliminar "${producto.nombre}"?`)) {
      this.productoService.deleteProducto(producto.id!).subscribe({
        next: () => {
          alert('Producto eliminado exitosamente');
          this.cargarProductos();
        },
        error: (err) => {
          console.error('Error al eliminar:', err);
          alert('Error al eliminar el producto. Verifica que el backend esté corriendo.');
        }
      });
    }
  }

  cerrarModal(): void {
    const modalElement = document.getElementById('productoModal');
    const modal = bootstrap.Modal.getInstance(modalElement);
    if (modal) {
      modal.hide();
    }
  }

  getNombreCategoria(categoriaId: number): string {
    const categoria = this.categorias.find(c => c.id === categoriaId);
    return categoria ? categoria.nombre : 'Sin categoría';
  }
}
