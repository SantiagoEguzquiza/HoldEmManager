import { Component, OnInit } from '@angular/core';
import { Ranking, RankingEnum } from 'src/app/models/ranking';
import { RankingService } from 'src/app/service/ranking.service';
import { ToastrService } from 'ngx-toastr';
import Swal from 'sweetalert2';
import * as XLSX from 'xlsx';

@Component({
  selector: 'app-ranking',
  templateUrl: './ranking.component.html',
  styleUrls: ['./ranking.component.css']
})
export class RankingComponent implements OnInit {

  loading = true;

  isCreate = false;
  isEdit = false;
  rankingEditado!: Ranking;

  page = 1;
  pageSize = 10;
  hasNextPage = false;

  cacheRankings: { [key: string]: { [page: number]: Ranking[] } } = {
    [RankingEnum.POKER]: {},
    [RankingEnum.FULLHOUSE]: {},
    [RankingEnum.ESCALERAREAL]: {}
  };

  filteredPokerRankings: Ranking[] = [];
  filteredFullHouseRankings: Ranking[] = [];
  filteredEscaleraRealRankings: Ranking[] = [];
  rankings: Ranking[] = [];
  filteredRankings: Ranking[] = [];
  public RankingEnum = RankingEnum;
  titulo: string = 'Ranking';
  rankingActual: RankingEnum = RankingEnum.POKER;

  constructor(private rankingService: RankingService, private toastr: ToastrService) { }

  ngOnInit(): void {
    this.obtenerRankingsPorTipo();
  }

  obtenerRankingsPorTipo(rankingEnum: RankingEnum = this.rankingActual): void {
    this.loading = true;
    
    if (this.cacheRankings[rankingEnum][this.page]) {
      this.asignarRankingsDesdeCache(rankingEnum);
  
      this.hasNextPage = this.cacheRankings[rankingEnum][this.page].length === this.pageSize;
      this.loading = false;
    } else {
      this.rankingService.obtenerRankingPorTipo(rankingEnum, this.page, this.pageSize).subscribe(
        (result) => {
          this.cacheRankings[rankingEnum][this.page] = result.items;
  
          this.hasNextPage = result.hasNextPage;
  
          this.asignarRankingsDesdeCache(rankingEnum);
          this.loading = false;
        },
        (error) => {
          console.error(error);
          this.loading = false;
        }
      );
    }
  }

  asignarRankingsDesdeCache(rankingEnum: RankingEnum): void {
    if (rankingEnum === RankingEnum.POKER) {
      this.filteredPokerRankings = this.cacheRankings[RankingEnum.POKER][this.page] || [];
    } else if (rankingEnum === RankingEnum.FULLHOUSE) {
      this.filteredFullHouseRankings = this.cacheRankings[RankingEnum.FULLHOUSE][this.page] || [];
    } else if (rankingEnum === RankingEnum.ESCALERAREAL) {
      this.filteredEscaleraRealRankings = this.cacheRankings[RankingEnum.ESCALERAREAL][this.page] || [];
    }
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
                this.cacheRankings[this.rankingActual] = {};
                this.toastr.success('Ranking actualizado exitosamente');
                this.isEdit = false;
                this.obtenerRankingsPorTipo();
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
          this.cacheRankings[this.rankingActual] = {};
          this.toastr.success('Jugador agregado al ranking exitosamente');
          this.isCreate = false;
          this.obtenerRankingsPorTipo();
      },
      (error) => {
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
            this.obtenerRankingsPorTipo();
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
    this.rankingActual = rankingEnum;
    this.page = 1;
    this.obtenerRankingsPorTipo(rankingEnum);
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

  async importarRanking(event: any): Promise<void> {
    this.loading = true;
    const input = event.target as HTMLInputElement;

    if (input.files && input.files.length === 1) {
      const file: File = input.files[0];
      const fileName = file.name.toLowerCase();
      if (!fileName.endsWith('.xlsx')) {
        this.toastr.error('Por favor, selecciona un archivo con extensión .xlsx.', 'Error');
        this.loading = false;
        return;
      }

      const reader: FileReader = new FileReader();

      reader.onload = async (e: any) => {
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

        try {
          await this.procesarRankings(rankings);
          this.toastr.success('Rankings procesados exitosamente');
          this.obtenerRankingsPorTipo();
        } catch (error) {
          this.toastr.error('Error al procesar rankings', 'Error');
          console.error(error);
        } finally {
          this.loading = false;
        }
      };

      reader.readAsBinaryString(file);
    } else {
      this.toastr.error('Por favor, selecciona un único archivo.', 'Error');
      this.loading = false;
    }
  }

  private async procesarRankings(rankings: Ranking[]): Promise<void> {
    const updatePromises = rankings.map(async (ranking) => {
      try {
        const existingRanking = await this.rankingService.obtenerRankingPorNumero(ranking.playerNumber).toPromise();
        if (existingRanking) {
          if (existingRanking.puntuacion !== ranking.puntuacion || existingRanking.rankingEnum !== ranking.rankingEnum) {
            existingRanking.puntuacion = ranking.puntuacion;
            existingRanking.rankingEnum = ranking.rankingEnum;
            await this.rankingService.actualizarRanking(existingRanking).toPromise();
          }
        } else {
          await this.rankingService.agregarRanking(ranking).toPromise();
        }
      } catch (error: any) {
        if (error.status === 400 || error.status === 404) {
          await this.rankingService.agregarRanking(ranking).toPromise();
        } else {
          throw error;
        }
      }
    });

    await Promise.all(updatePromises);
  }

  onPageChange(newPage: number) {
    if (newPage > 0) {
      this.page = newPage;
      this.obtenerRankingsPorTipo();
    }
  }
}