import { Component, OnInit } from '@angular/core';
import { Jugador } from 'src/app/models/jugador';
import { PlayersService } from 'src/app/service/players.service';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-players',
  templateUrl: './players.component.html',
  styleUrls: ['./players.component.css']
})
export class PlayersComponent implements OnInit {

  jugadores: Jugador[] = [];
  loading = false;

  constructor(private playersService: PlayersService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerJugadores();
  }

  obtenerJugadores(): void {
    this.loading = true;
    this.playersService.obtenerJugadores().subscribe(
      (data) => {
        this.jugadores = data;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        this.toastr.error('Error al obtener recursos', 'Error');
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
      confirmButtonColor: '#f59f00', 
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
            this.obtenerJugadores(); // para que se actualice la lista después de borrarlos
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

  agregarJugador(){

    this.router.navigate(['/dashboard/create-player']);
  }

  editarJugador(jugador: Jugador): void {
    this.router.navigate(['/dashboard/edit-player', jugador.id]);
  }
}
