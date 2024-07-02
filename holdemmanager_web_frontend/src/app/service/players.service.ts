import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Jugador } from '../models/jugador';

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

  obtenerPlayerPorId(id: number): Observable<Jugador> {
    return this.http.get<Jugador>(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  obtenerJugadores(): Observable<Jugador[]> {
    return this.http.get<Jugador[]>(this.myAppUrl + this.myApiUrlWeb);
  }

  eliminarJugador(id: number): Observable<any> {
    return this.http.delete(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  actualizarJugador(jugador: Jugador): Observable<Jugador> {
    return this.http.put<Jugador>(`${this.myAppUrl + this.myApiUrlWeb}/UpdateUser/${jugador.id}`, jugador);
  }


}
