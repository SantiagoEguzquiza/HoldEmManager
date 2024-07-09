import { Component, EventEmitter, Output } from '@angular/core';

interface Jugador {
  id: number;
  numberPlayer: number;
  name: string;
  email: string;
  password: string;
  imageUrl?: string;
}

@Component({
  selector: 'app-create-player',
  templateUrl: './create-player.component.html',
  styleUrls: ['./create-player.component.css']
})
export class CreatePlayerComponent {
  nuevoJugador: Jugador = {
    id: 0,
    numberPlayer: 0,
    name: '',
    email: '',
    password: '',
    imageUrl: ''
  };

  @Output() guardar = new EventEmitter<Jugador>();
  @Output() cancelar = new EventEmitter<void>();

  guardarJugador() {
    this.guardar.emit(this.nuevoJugador);
  }

  cancelarCreacion() {
    this.cancelar.emit();
  }
}
