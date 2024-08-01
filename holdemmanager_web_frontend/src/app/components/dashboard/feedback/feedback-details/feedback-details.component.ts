import { Component, EventEmitter, Input, OnChanges, Output, SimpleChanges } from '@angular/core';
import { Feedback } from 'src/app/models/feedback';
import { Jugador } from 'src/app/models/jugador';

@Component({
  selector: 'app-feedback-create',
  templateUrl: './feedback-details.component.html',
  styleUrls: ['./feedback-details.component.css']
})
export class FeedbackDetailsComponent {
  @Input() feedback: Feedback | null = null;
  @Input() jugador: Jugador | null = null; 
  @Output() cerrar = new EventEmitter<void>();

  cerrarPopup() {
    this.cerrar.emit();
  }
}
