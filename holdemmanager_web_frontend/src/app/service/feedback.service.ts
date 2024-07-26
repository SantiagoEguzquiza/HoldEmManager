import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Feedback } from '../models/feedback';
import { Jugador } from '../models/jugador';

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

  obtenerFeedbacks(): Observable<Feedback[]> {
    return this.http.get<Feedback[]>(this.myAppUrl + this.myApiUrlWeb);
  }

  obtenerUsuario(id: number): Observable<Jugador> {
    return this.http.get<Jugador>(`${this.myAppUrl}/JugadorApp/${id}`);
  }
}