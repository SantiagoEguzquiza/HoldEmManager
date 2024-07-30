import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Torneos } from '../models/torneos';

@Injectable({
  providedIn: 'root'
})
export class TorneosService {
  myAppUrl: string;
  myApiUrlWeb: string;

  constructor(private http: HttpClient) {
    this.myAppUrl = environment.endpoint;
    this.myApiUrlWeb = '/TorneosWeb';
  }

  crearTorneo(torneo: Torneos): Observable<any> {
    return this.http.post(this.myAppUrl + this.myApiUrlWeb, torneo);
  }

  obtenerTorneos(): Observable<Torneos[]> {
    return this.http.get<Torneos[]>(this.myAppUrl + this.myApiUrlWeb);
  }

  obtenerTorneoPorId(id: number): Observable<Torneos> {
    return this.http.get<Torneos>(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  actualizarTorneo(torneo: Torneos): Observable<Torneos> {
    return this.http.put<Torneos>(`${this.myAppUrl + this.myApiUrlWeb}/${torneo.id}`, torneo);
  }

  eliminarTorneo(id: number): Observable<any> {
    return this.http.delete(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }
}