import { Component, OnInit } from '@angular/core';

import { Ranking, RankingEnum } from 'src/app/models/ranking';
import { RankingService } from 'src/app/service/ranking.service';
import { ToastrService } from 'ngx-toastr';
import Swal from 'sweetalert2';
import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';

@Component({
  selector: 'app-ranking',
  templateUrl: './ranking.component.html',
  styleUrls: ['./ranking.component.css']
})
export class RankingComponent implements OnInit {

  loading = false;

  isCreate = false;
  isEdit = false;
  rankingEditado!: Ranking;

  rankings: Ranking[] = [];
  filteredRankings: Ranking[] = [];
  public RankingEnum = RankingEnum;
  titulo: string = 'Ranking';

  constructor(private rankingService: RankingService, private toastr: ToastrService) { }

  ngOnInit(): void {
    this.obtenerRankings();
  }

  obtenerRankings(): void {
    this.loading = true;
    this.rankingService.obtenerRanking().subscribe((data: Ranking[]) => {
      this.rankings = data;
      this.filtrarPorRankingEnum(RankingEnum.POKER); // Filtra automáticamente por Poker al cargar
      this.loading = false;
    });
  }

  agregarRanking() {
    this.isCreate = true;
  }

  cancelarNuevoRanking() {
    this.isCreate = false;
  }

  cancelarEditarRanking() {
    this.isEdit = false;
  }

  editarRanking(ranking: Ranking) {
    this.rankingEditado = ranking;
    this.isEdit = true;
  }

  guardarJugadorEditado(rankingEditado: Ranking) {
    if (this.rankingEditado) {
      this.rankingService.actualizarRanking(rankingEditado).subscribe(
        (data: Ranking) => {
          const index = this.rankings.findIndex(j => j.id === this.rankingEditado!.id);
          if (index !== -1) {
            this.rankings[index] = data;
          }
          this.toastr.success('Ranking actualizado exitosamente');
          this.isEdit = false;
          this.obtenerRankings();
        },
        (error) => {
          this.toastr.error('Error al editar el ranking', 'Error');
          console.error(error);
        }
      );
    }
  }

  guardarNuevoRanking(nuevoRanking: Ranking) {
    this.rankingService.agregarRanking(nuevoRanking).subscribe(
      (data: Ranking) => {
        this.rankings.push(data);
        this.toastr.success('Jugador agregado al ranking exitosamente');
        this.isCreate = false;
        this.obtenerRankings();
      },

      (error) => {
        console.log(nuevoRanking);
        this.toastr.error(error?.error?.message, 'Error');
        console.log(error);
      }
    );
  }

  eliminarRanking(id: number): void {
    Swal.fire({
      title: '¿Estás seguro de eliminar este jugador del Ranking?',
      text: 'No podrás revertir esta acción',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#b4540f',
      confirmButtonText: 'Sí, eliminar',
      cancelButtonText: 'Cancelar',
      customClass: {
        cancelButton: 'swal2-cancel-button',
        confirmButton: 'swal2-confirm-button'
      }
    }).then((result) => {
      if (result.isConfirmed) {
        this.loading = true;
        this.rankingService.eliminarRanking(id).subscribe(
          () => {
            this.toastr.success('Jugador eliminado correctamente', 'Éxito');
            this.obtenerRankings();
          },
          (error) => {
            this.loading = false;
            this.toastr.error('Error al eliminar el jugador', 'Error');
            console.error(error);
          }
        );
      }
    });
  }


  filtrarPorRankingEnum(rankingEnum: RankingEnum): void {
    this.filteredRankings = this.rankings.filter(r => r.rankingEnum === rankingEnum);
    this.actualizarTitulo(rankingEnum);
  }

  actualizarTitulo(rankingEnum: RankingEnum): void {
    switch (rankingEnum) {
      case RankingEnum.POKER:
        this.titulo = "Ranking Poker";
        break;
      case RankingEnum.FULLHOUSE:
        this.titulo = "Ranking FullHouse";
        break;
      case RankingEnum.ESCALERAREAL:
        this.titulo = "Ranking Escalera Real";
        break;
      default:
        this.titulo = "Ranking";
    }
  }

  obtenerNombreRankingEnum(value: RankingEnum): string {
    return RankingEnum[value];
  }

  importarRanking(event: any): void {
    const input = event.target as HTMLInputElement;

    if (input.files && input.files.length === 1) {
        const file: File = input.files[0];
        const fileName = file.name.toLowerCase();
        if (!fileName.endsWith('.xlsx')) {
            this.toastr.error('Por favor, selecciona un archivo con extensión .xlsx.', 'Error');
            return;
        }

        const reader: FileReader = new FileReader();

        reader.onload = (e: any) => {
            const bstr: string = e.target.result;
            const wb: XLSX.WorkBook = XLSX.read(bstr, { type: 'binary' });

            const wsname: string = wb.SheetNames[0];
            const ws: XLSX.WorkSheet = wb.Sheets[wsname];

            const data: any[] = XLSX.utils.sheet_to_json(ws, { header: 1 });

            const rankings: Ranking[] = data.slice(1).map(row => ({
                playerNumber: row[0],
                playerName: row[1],
                puntuacion: row[2],
                rankingEnum: row[3]
            }));

            const updatePromises = rankings.map(ranking =>
                this.rankingService.obtenerRankingPorNumero(ranking.playerNumber).toPromise().then(
                    (existingRanking) => {
                        if (existingRanking) {
                            // Si el jugador ya existe, actualizar si la puntuación es diferente o el rankingEnum
                            if (existingRanking.puntuacion !== ranking.puntuacion || existingRanking.rankingEnum !== ranking.rankingEnum) {
                                existingRanking.puntuacion = ranking.puntuacion;
                                existingRanking.rankingEnum = ranking.rankingEnum;
                                return this.rankingService.actualizarRanking(existingRanking).toPromise();
                            } else {
                                return Promise.resolve(null); // No hace nada si la puntuación es igual
                            }
                        } else {
                            // Si el jugador no existe, agregarlo
                            return this.rankingService.agregarRanking(ranking).toPromise();
                        }
                    }
                ).catch((error) => {
                    if (error.status === 400) {
                        // Si el error es 400 y el mensaje indica que no se encontró el jugador
                        return this.rankingService.agregarRanking(ranking).toPromise();
                    } else {
                        this.toastr.error('Error al verificar o actualizar el jugador', 'Error');
                        console.error(error);
                        return Promise.reject(error);
                    }
                })
            );

            Promise.all(updatePromises).then(() => {
                this.toastr.success('Rankings procesados exitosamente');
                this.obtenerRankings();
            }).catch((error) => {
                this.toastr.error('Error al procesar rankings', 'Error');
                console.error(error);
            });
        };

        reader.readAsBinaryString(file);
    } else {
        this.toastr.error('Por favor, selecciona un único archivo.', 'Error');
    }
}



}

