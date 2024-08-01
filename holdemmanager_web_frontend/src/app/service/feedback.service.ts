import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Feedback } from '../models/feedback';
import { Jugador } from '../models/jugador';
import { PagedResult } from '../helpers/pagedResult';

@Injectable({
  providedIn: 'root'
})
export class FeedbackService {
  myAppUrl: string;
  myApiUrlWeb: string;

  constructor(private http: HttpClient) {
    this.myAppUrl = environment.endpoint;
    this.myApiUrlWeb = '/FeedbackApp';
  }

  obtenerFeedbacks(page: number, pageSize: number): Observable<PagedResult<Feedback>> {
    const params = new HttpParams()
    .set('page', page.toString())
    .set('pageSize', pageSize.toString());
  
  return this.http.get<PagedResult<Feedback>>(this.myAppUrl + this.myApiUrlWeb, { params });
  }

  obtenerUsuario(id: number): Observable<Jugador> {
    return this.http.get<Jugador>(`${this.myAppUrl}/JugadorApp/id/${id}`);
  }
}