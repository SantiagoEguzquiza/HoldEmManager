import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment.development';
import { Ranking } from '../models/ranking';

@Injectable({
  providedIn: 'root'
})
export class RankingService {

  private myAppUrl = environment.endpoint;
  private myApiUrlWeb = '/RankingWeb';

  constructor(private http: HttpClient) { }

  obtenerRanking(): Observable<Ranking[]> {
    return this.http.get<Ranking[]>(this.myAppUrl + this.myApiUrlWeb);
  }

  eliminarRanking(id: number): Observable<any> {
    return this.http.delete<void>(`${this.myAppUrl + this.myApiUrlWeb}/${id}`);
  }

  agregarRanking(ranking: Ranking): Observable<Ranking> {
    return this.http.post<Ranking>(this.myAppUrl + this.myApiUrlWeb, ranking);
  }

  actualizarRanking(ranking: Ranking): Observable<Ranking> {
    return this.http.put<Ranking>(`${this.myAppUrl + this.myApiUrlWeb}/${ranking.id}`, ranking);
  }

  importarRankings(rankings: Ranking[]): Observable<void> {
    return this.http.post<void>( this.myAppUrl + this.myApiUrlWeb + '/importRanking', rankings);
  }

  obtenerRankingPorNumero(number: number): Observable<Ranking> {
    return this.http.get<Ranking>(`${this.myAppUrl + this.myApiUrlWeb + '/getByNumber'}/${number}`);
  }
}



