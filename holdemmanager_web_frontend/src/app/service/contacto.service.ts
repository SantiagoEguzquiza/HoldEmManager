import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Contacto } from '../models/contactos';
import { PagedResult } from '../helpers/pagedResult';

@Injectable({
  providedIn: 'root'
})
export class ContactoService {
  myAppUrl: string;
  myApiUrlWeb: string;

  constructor(private http: HttpClient) {
    this.myAppUrl = environment.endpoint;
    this.myApiUrlWeb = '/ContactoWeb';
  }

  agregarContacto(contacto: Contacto): Observable<Contacto> {
    return this.http.post<Contacto>(this.myAppUrl + this.myApiUrlWeb, contacto);
  }

  obtenerContactos(page: number, pageSize: number): Observable<PagedResult<Contacto>> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString());
    
    return this.http.get<PagedResult<Contacto>>(this.myAppUrl + this.myApiUrlWeb, { params });
  }

  obtenerContactoPorId(id: number): Observable<Contacto> {
    return this.http.get<Contacto>(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  actualizarContacto(contacto: Contacto): Observable<Contacto> {
    return this.http.put<Contacto>(`${this.myAppUrl + this.myApiUrlWeb}/${contacto.id}`, contacto);
  }

  eliminarContacto(id: number): Observable<any> {
    return this.http.delete(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }
}