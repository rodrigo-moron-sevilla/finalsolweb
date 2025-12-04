import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private isAuthenticatedSubject = new BehaviorSubject<boolean>(this.hasToken());
  public isAuthenticated$: Observable<boolean> = this.isAuthenticatedSubject.asObservable();

  constructor() { }

  private hasToken(): boolean {
    return localStorage.getItem('adminToken') !== null;
  }

  login(username: string, password: string): boolean {
    // Credenciales de ejemplo - puedes cambiarlas
    if (username === 'admin' && password === 'admin123') {
      localStorage.setItem('adminToken', 'authenticated');
      localStorage.setItem('adminUser', username);
      this.isAuthenticatedSubject.next(true);
      return true;
    }
    return false;
  }

  logout(): void {
    localStorage.removeItem('adminToken');
    localStorage.removeItem('adminUser');
    this.isAuthenticatedSubject.next(false);
  }

  isAuthenticated(): boolean {
    return this.hasToken();
  }

  getUsername(): string | null {
    return localStorage.getItem('adminUser');
  }
}
