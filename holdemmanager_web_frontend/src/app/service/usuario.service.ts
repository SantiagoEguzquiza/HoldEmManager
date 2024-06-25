import { Injectable } from '@angular/core';
import { Jugador } from '../models/jugador';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class UsuarioService {
  myAppUrl: string;
  myApiUrlApp: string;
  myApiUrlWeb: string;

  constructor(private http: HttpClient) {
    this.myAppUrl = environment.endpoint;
    this.myApiUrlApp = '/JugadorApp';
    this.myApiUrlWeb = '/UsuarioWeb';
  }

  saveUser(usuario: Jugador): Observable<any> {
    return this.http.post(this.myAppUrl + this.myApiUrlApp, usuario);
  }

  getUsuario(): Observable<any> {    
    return this.http.get(this.myAppUrl + this.myApiUrlWeb + '/GetUsuario');
  }
}
