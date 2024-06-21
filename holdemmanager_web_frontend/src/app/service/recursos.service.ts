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
    //myApiUrlApp: string;
    myApiUrlWeb: string;
  
    constructor(private http: HttpClient) {
      this.myAppUrl = environment.endpoint;
      this.myApiUrlWeb = '/RecursosEducativosWeb';
    }
  
    saveRecurso(recurso: RecursosEducativos): Observable<any> {
      return this.http.post(this.myAppUrl + this.myApiUrlWeb, recurso);
    }
  }