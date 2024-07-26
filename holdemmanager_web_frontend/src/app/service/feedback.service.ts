import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment.development';
import { Observable } from 'rxjs';
import { Feedback } from '../models/feedback';

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
}