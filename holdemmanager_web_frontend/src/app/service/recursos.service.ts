import { Injectable } from '@angular/core';
import { RecursosEducativos } from '../models/recursos';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';

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

  saveRecurso(recurso: RecursosEducativos): Observable<any> {
    return this.http.post(this.myAppUrl + this.myApiUrlWeb, recurso);
  }

  obtenerRecursos(): Observable<RecursosEducativos[]> {
    return this.http.get<RecursosEducativos[]>(this.myAppUrl + this.myApiUrlWeb);
  }

  obtenerRecursoPorId(id: number): Observable<RecursosEducativos> {
    return this.http.get<RecursosEducativos>(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  actualizarRecurso(recurso: RecursosEducativos): Observable<RecursosEducativos> {
    return this.http.put<RecursosEducativos>(`${this.myAppUrl + this.myApiUrlWeb}/${recurso.id}`, recurso);
  }

  eliminarRecurso(id: number): Observable<any> {
    return this.http.delete(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }
}