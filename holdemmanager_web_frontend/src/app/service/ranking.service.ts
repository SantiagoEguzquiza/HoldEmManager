import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment.development';

@Injectable({
  providedIn: 'root'
})
export class RankingService {

  myAppUrl: string;
  myApiUrlWeb: string;



  constructor(private http: HttpClient) {

    this.myAppUrl = environment.endpoint;
    this.myApiUrlWeb = '/JugadorApp';
  }


}
