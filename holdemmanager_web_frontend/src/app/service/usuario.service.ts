import { Injectable } from '@angular/core';
import { UsuarioApp } from '../models/usuarioApp';
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
    this.myApiUrlApp = '/UsuarioApp';
    this.myApiUrlWeb = '/UsuarioWeb';
  }

  saveUser(usuario: UsuarioApp): Observable<any> {
    return this.http.post(this.myAppUrl + this.myApiUrlApp, usuario);
  }

  getUsuario(): Observable<any> {    
    return this.http.get(this.myAppUrl + this.myApiUrlWeb + '/GetUsuario');
  }
}
