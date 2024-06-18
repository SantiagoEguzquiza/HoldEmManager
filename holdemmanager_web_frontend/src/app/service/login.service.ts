import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment.development';
import { UsuarioWeb } from '../models/usuarioWeb';
import { JwtHelperService } from '@auth0/angular-jwt';

@Injectable({
  providedIn: 'root'
})
export class LoginService {
  myAppUrl: string;
  myApiUrl: string;

  constructor(private http: HttpClient) {

    this.myAppUrl = environment.endpoint;
    this.myApiUrl = '/LoginWeb';
  }

  login(usuario: UsuarioWeb): Observable<any> {
    return this.http.post(this.myAppUrl + this.myApiUrl, usuario)
  }

  setLocalStorage(data: any): void {
    localStorage.setItem('token', data);
  }

  getTokenDecoded(): any {
    const helper = new JwtHelperService();
    const token = localStorage.getItem('token');

    if (token) {
      const decodedToken = helper.decodeToken(token);
      return decodedToken;
    } else {
      return null;
    }
  }

  removeLocaStorage(): void {
    localStorage.removeItem('token');
  }
}
