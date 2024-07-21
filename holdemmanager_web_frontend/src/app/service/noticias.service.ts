import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Noticias } from '../models/noticias';

@Injectable({
  providedIn: 'root'
})
export class NoticiasService {

  myAppUrl: string;
  myApiUrlWeb: string;


  constructor(private http: HttpClient) {
    this.myAppUrl = environment.endpoint;
    this.myApiUrlWeb = '/NoticiasWeb';
  }

  agregarNoticia(noticia: Noticias): Observable<any> {
    return this.http.post(this.myAppUrl + this.myApiUrlWeb, noticia);
  }

  obtenerNoticias(): Observable<Noticias[]> {
    return this.http.get<Noticias[]>(this.myAppUrl + this.myApiUrlWeb);
  }

  obtenerNoticiaPorId(id: number): Observable<Noticias> {
    return this.http.get<Noticias>(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  actualizarNoticia(noticia: Noticias): Observable<Noticias> {
    return this.http.put<Noticias>(`${this.myAppUrl + this.myApiUrlWeb}/${noticia.id}`, noticia);
  }

  eliminarNoticia(id: number): Observable<any> {
    return this.http.delete(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }
}