import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Contactos } from '../models/contactos';

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

  saveContacto(contacto: Contactos): Observable<any> {
    return this.http.post(this.myAppUrl + this.myApiUrlWeb, contacto);
  }

  obtenerContactos(): Observable<Contactos[]> {
    return this.http.get<Contactos[]>(this.myAppUrl + this.myApiUrlWeb);
  }

  obtenerContactoPorId(id: number): Observable<Contactos> {
    return this.http.get<Contactos>(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  actualizarContacto(contacto: Contactos): Observable<Contactos> {
    return this.http.put<Contactos>(`${this.myAppUrl + this.myApiUrlWeb}/${contacto.id}`, contacto);
  }

  eliminarContacto(id: number): Observable<any> {
    return this.http.delete(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }
}