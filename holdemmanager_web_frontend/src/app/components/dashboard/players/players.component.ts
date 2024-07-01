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
  }


  editarJugador(jugador: Jugador): void {
    this.router.navigate(['/dashboard/edit-recurso', jugador.id]);
  }


}
