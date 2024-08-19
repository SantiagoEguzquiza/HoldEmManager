import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Torneos } from '../models/torneos';
import { PagedResult } from '../helpers/pagedResult';

@Injectable({
  providedIn: 'root'
})
export class TorneosService {
  private myAppUrl = environment.endpoint;
  private myApiUrlWeb = '/TorneosWeb';

  constructor(private http: HttpClient) { }

  crearTorneo(torneo: Torneos): Observable<any> {
    return this.http.post(this.myAppUrl + this.myApiUrlWeb, torneo);
  }

  obtenerTorneos(page: number, pageSize: number, filtro : string, filtroFecha: string | null): Observable<PagedResult<Torneos>> {
    if (filtro == '') {
      filtro = 'NO';
    }

    const params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString())
      .set('filtro', filtro.toString())
      .set('filtroFecha', filtroFecha!);

    return this.http.get<PagedResult<Torneos>>(this.myAppUrl + this.myApiUrlWeb, { params });
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