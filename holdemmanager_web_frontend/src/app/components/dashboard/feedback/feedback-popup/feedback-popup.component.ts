import { Component, EventEmitter, Input, OnChanges, Output, SimpleChanges } from '@angular/core';

interface Feedback {
  id?: number;
  mensaje: string;
  fecha: Date;
  idUsuario: number;
}

interface Jugador {
    id?: number;
    numberPlayer: number;
    name: string;
    email: string;
    password: string;
}

@Component({
  selector: 'app-feedback-popup',
  templateUrl: './feedback-popup.component.html',
  styleUrls: ['./feedback-popup.component.css']
})
export class FeedbackPopupComponent implements OnChanges {
  @Input() feedback: Feedback | null = null;
  @Input() jugador: Jugador | null = null; 
  @Output() cerrar = new EventEmitter<void>();

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['feedback'] && this.feedback) {
      
    }

    if (changes['usuario'] && this.jugador) {
      
    }
  }

  cerrarPopup() {
    this.cerrar.emit();
  }
}
