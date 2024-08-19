import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Noticia } from '../models/noticias';
import { environment } from 'src/environments/environment.development';
import { PagedResult } from '../helpers/pagedResult';

@Injectable({
  providedIn: 'root'
})
export class NoticiasService {
  private myAppUrl = environment.endpoint;
  private myApiUrlWeb = '/NoticiasWeb';

  constructor(private http: HttpClient) { }

  obtenerNoticias(page: number, pageSize: number, filtro: string, filtroFecha: string | null): Observable<PagedResult<Noticia>> {
    if (filtro == '') {
      filtro = 'NO';
    }

    const params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString())
      .set('filtro', filtro.toString())
      .set('filtroFecha', filtroFecha!);

    return this.http.get<PagedResult<Noticia>>(this.myAppUrl + this.myApiUrlWeb, { params });
  }

  eliminarNoticia(id: number): Observable<void> {
    return this.http.delete<void>(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  agregarNoticia(noticia: Noticia): Observable<Noticia> {
    return this.http.post<Noticia>(this.myAppUrl + this.myApiUrlWeb, noticia);
  }

  actualizarNoticia(noticia: Noticia): Observable<Noticia> {
    return this.http.put<Noticia>(`${this.myAppUrl + this.myApiUrlWeb}/${noticia.id}`, noticia);
  }
}