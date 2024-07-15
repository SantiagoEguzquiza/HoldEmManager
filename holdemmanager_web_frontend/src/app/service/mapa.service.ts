import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { MapaHelper } from '../helpers/mapaHelper';

@Injectable({
  providedIn: 'root'
})
export class MapaService {
  myAppUrl: string;
  myApiUrl: string;

  constructor(private http: HttpClient) {
    this.myAppUrl = environment.endpoint;
    this.myApiUrl = '/MapaApp';
  }

  saveMapa(mapa: MapaHelper): Observable<any> {    
    console.log(mapa);
    
    return this.http.post(this.myAppUrl + this.myApiUrl, mapa);
  }
}