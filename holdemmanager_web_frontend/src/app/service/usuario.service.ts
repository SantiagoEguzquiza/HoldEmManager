import { Injectable } from '@angular/core';
import { UsuarioApp } from '../models/usuario';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class UsuarioService {
  myAppUrl: string;
  myApiUrl: string;

  constructor(private http: HttpClient) {
    this.myAppUrl = environment.endpoint;
    this.myApiUrl = '/UsuarioApp';
  }

  saveUser(usuario: UsuarioApp): Observable<any> {    
    return this.http.post(this.myAppUrl+this.myApiUrl,usuario);
  }

  changePassword(changePassword:any):Observable<any>{
    return this.http.put(this.myAppUrl + this.myApiUrl + '/CambiarPassword',changePassword);
  }
}
