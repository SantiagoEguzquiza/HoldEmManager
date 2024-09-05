import { Component, OnInit } from '@angular/core';
import { PlayersService } from 'src/app/service/players.service';
import { ToastrService } from 'ngx-toastr';
import Swal from 'sweetalert2';
import { Jugador } from 'src/app/models/jugador';
import { PagedResult } from 'src/app/helpers/pagedResult';

@Component({
  selector: 'app-players',
  templateUrl: './players.component.html',
  styleUrls: ['./players.component.css']
})
export class PlayersComponent implements OnInit {

  isCreateJugador = false;
  isEditJugador = false;
  jugadores: Jugador[] = [];
  loading = false;
  jugadorEditado!: Jugador;
  page = 1;
  pageSize = 10;
  hasNextPage = false;

  constructor(private playersService: PlayersService, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerJugadores();
  }

  obtenerJugadores(): void {
    this.loading = true;
    this.playersService.obtenerJugadores(this.page, this.pageSize).subscribe(
      (data: PagedResult<Jugador>) => {
        this.jugadores = data.items;
        this.hasNextPage = data.hasNextPage;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        this.toastr.error('Error al obtener jugadores', 'Error');
        console.error(error);
      }
    );
  }

  eliminarJugador(id: number): void {
    Swal.fire({
      title: '¿Estás seguro de eliminar este jugador?',
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
        this.playersService.eliminarJugador(id).subscribe(
          () => {
            this.toastr.success('Jugador eliminado correctamente', 'Éxito');
            this.obtenerJugadores();
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

  agregarJugador() {
    this.isCreateJugador = true;
  }

  editarJugador(jugador: Jugador): void {
    this.jugadorEditado = jugador;
    this.isEditJugador = true;
  }

  guardarNuevoJugador(nuevoJugador: Jugador) {
    this.playersService.agregarJugador(nuevoJugador).subscribe(
      (data: Jugador) => {
        this.jugadores.push(data);
        this.toastr.success('Jugador agregado exitosamente');
        this.isCreateJugador = false;
        this.obtenerJugadores();
      },
      (error) => {
        this.toastr.error(error.error.message, 'Error');
        console.log(error);
      }
    );
  }

  guardarJugadorEditado(jugadorEditado: Jugador) {
    if (this.jugadorEditado) {
      this.playersService.actualizarJugador(jugadorEditado).subscribe(
        (data: Jugador) => {
          const index = this.jugadores.findIndex(j => j.id === this.jugadorEditado!.id);
          if (index !== -1) {
            this.jugadores[index] = data;
          }
          this.toastr.success('Jugador editado exitosamente');
          this.isEditJugador = false;
          this.obtenerJugadores();
        },
        (error) => {
          this.toastr.error('Error al editar jugador', 'Error');
          console.error(error);
        }
      );
    }
  }

  cancelarNuevoJugador() {
    this.isCreateJugador = false;
  }

  cancelarEditarJugador() {
    this.isEditJugador = false;
  }

  onPageChange(newPage: number) {
    if (newPage > 0 && (newPage < this.page || this.hasNextPage)) {
      this.page = newPage;
      this.obtenerJugadores();
    }
  }
}