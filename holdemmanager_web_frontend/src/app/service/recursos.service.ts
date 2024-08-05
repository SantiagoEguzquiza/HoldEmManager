import { Injectable } from '@angular/core';
import { RecursoEducativo } from '../models/recursos';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { PagedResult } from '../helpers/pagedResult';

@Injectable({
  providedIn: 'root'
})
export class RecursosService {
  myAppUrl: string;
  myApiUrlWeb: string;

  constructor(private http: HttpClient) {
    this.myAppUrl = environment.endpoint;
    this.myApiUrlWeb = '/RecursosEducativosWeb';
  }

  obtenerRecursos(page: number, pageSize: number, filtro: string): Observable<PagedResult<RecursoEducativo>> {
    if (filtro == '') {
      filtro = 'NO';
    }

    let params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString())
      .set('filtro', filtro.toString());

    return this.http.get<PagedResult<RecursoEducativo>>(this.myAppUrl + this.myApiUrlWeb, { params });
  }

  agregarRecurso(recurso: RecursoEducativo): Observable<any> {
    console.log(this.myAppUrl + this.myApiUrlWeb);

    return this.http.post(this.myAppUrl + this.myApiUrlWeb, recurso);
  }

  obtenerRecursoPorId(id: number): Observable<RecursoEducativo> {
    return this.http.get<RecursoEducativo>(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  actualizarRecurso(recurso: RecursoEducativo): Observable<RecursoEducativo> {
    return this.http.put<RecursoEducativo>(`${this.myAppUrl + this.myApiUrlWeb}/${recurso.id}`, recurso);
  }

  eliminarRecurso(id: number): Observable<any> {
    return this.http.delete(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }
}