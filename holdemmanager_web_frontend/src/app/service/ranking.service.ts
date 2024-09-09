import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment.development';
import { Ranking, RankingEnum } from '../models/ranking';
import { PagedResult } from '../helpers/pagedResult';

@Injectable({
  providedIn: 'root'
})
export class RankingService {

  private myAppUrl = environment.endpoint;
  private myApiUrlWeb = '/RankingWeb';

  constructor(private http: HttpClient) { }

  obtenerRankingPorTipo(tipo: RankingEnum, page: number, pageSize: number): Observable<PagedResult<Ranking>> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString())
      .set('tipo', tipo);
    
    return this.http.get<PagedResult<Ranking>>(this.myAppUrl + this.myApiUrlWeb, { params });
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



