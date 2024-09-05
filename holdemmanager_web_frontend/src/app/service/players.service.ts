import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Jugador } from '../models/jugador';
import { PagedResult } from '../helpers/pagedResult';

@Injectable({
  providedIn: 'root'
})
export class PlayersService {

  myAppUrl: string;
  myApiUrlWeb: string;


  constructor(private http: HttpClient) {
    this.myAppUrl = environment.endpoint;
    this.myApiUrlWeb = '/JugadorApp';
  }

  agregarJugador(usuario: Jugador): Observable<any> {
    return this.http.post(this.myAppUrl + this.myApiUrlWeb, usuario);
  }

  obtenerPlayerPorId(id: number): Observable<Jugador> {
    return this.http.get<Jugador>(`${this.myAppUrl + this.myApiUrlWeb}/id/${id}`);
  }

  obtenerJugadores(page: number, pageSize: number, filtro: string): Observable<PagedResult<Jugador>> {
    if (filtro == '') {
      filtro = 'NO';
    }

    const params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString())
      .set('filtro', filtro.toString());

    return this.http.get<PagedResult<Jugador>>(this.myAppUrl + this.myApiUrlWeb, { params });
  }

  eliminarJugador(id: number): Observable<any> {
    return this.http.delete(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  actualizarJugador(jugador: Jugador): Observable<Jugador> {
    return this.http.put<Jugador>(`${this.myAppUrl + this.myApiUrlWeb}`, jugador);
  }
}
