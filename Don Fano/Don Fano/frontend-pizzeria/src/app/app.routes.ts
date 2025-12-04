import { Routes } from '@angular/router';
import { HomeComponent } from './components/home/home';
import { MenuComponent } from './components/menu/menu';
import { CarritoComponent } from './components/carrito/carrito';
import { LoginComponent } from './components/login/login';
import { AdminPanelComponent } from './components/admin-panel/admin-panel';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'menu', component: MenuComponent },
  { path: 'carrito', component: CarritoComponent },
  { path: 'login', component: LoginComponent },
  { path: 'admin', component: AdminPanelComponent },
  { path: '**', redirectTo: '' }
];
