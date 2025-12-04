import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink, RouterLinkActive } from '@angular/router';
import { CarritoService } from '../../services/carrito.service';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-navbar',
  imports: [CommonModule, RouterLink, RouterLinkActive],
  templateUrl: './navbar.html',
  styleUrl: './navbar.css'
})
export class NavbarComponent implements OnInit {
  cantidadItems: number = 0;
  isAuthenticated: boolean = false;
  username: string | null = null;

  constructor(
    private carritoService: CarritoService,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    // Suscribirse a cambios del carrito
    this.carritoService.cart$.subscribe(() => {
      this.cantidadItems = this.carritoService.getCantidadTotal();
    });

    // Suscribirse a cambios de autenticación
    this.authService.isAuthenticated$.subscribe(authenticated => {
      this.isAuthenticated = authenticated;
      this.username = this.authService.getUsername();
    });
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/']);
    alert('Sesión cerrada exitosamente');
  }
}
