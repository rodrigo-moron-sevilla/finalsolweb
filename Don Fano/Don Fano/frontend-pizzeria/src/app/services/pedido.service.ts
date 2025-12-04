import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Pedido, CreatePedidoDTO } from '../models/models';

@Injectable({
  providedIn: 'root'
})
export class PedidoService {
  private apiUrl = 'http://localhost:8080/api/pedidos';

  constructor(private http: HttpClient) { }

  // Crear nuevo pedido
  createPedido(pedidoDTO: CreatePedidoDTO): Observable<Pedido> {
    return this.http.post<Pedido>(this.apiUrl, pedidoDTO);
  }

  // Obtener pedidos por usuario
  getPedidosByUsuario(usuarioId: number): Observable<Pedido[]> {
    return this.http.get<Pedido[]>(`${this.apiUrl}/usuario/${usuarioId}`);
  }
}
