import { Component, EventEmitter, Input, OnChanges, Output, SimpleChanges } from '@angular/core';
import { Torneos } from 'src/app/models/torneos';

@Component({
  selector: 'app-create-torneo',
  templateUrl: './create-torneo.component.html',
  styleUrls: ['./create-torneo.component.css']
})
export class CreateTorneoComponent implements OnChanges {
  loading = false;

  @Input() torneo: Torneos | null = null;
  nuevoTorneo: Torneos = new Torneos();
  formattedDate: string = this.formatoFecha(new Date());

  @Output() guardar = new EventEmitter<Torneos>();
  @Output() cancelar = new EventEmitter<void>();

  constructor() { }
  ngOnChanges(changes: SimpleChanges): void {
    if (changes['torneo'] && changes['torneo'].currentValue !== null && changes['torneo'].currentValue !== undefined) {
      this.nuevoTorneo = { ...changes['torneo'].currentValue };
      this.formattedDate = this.formatoFecha(new Date(this.nuevoTorneo.fecha));
    } else {
      this.nuevoTorneo = new Torneos();
      this.formattedDate = this.formatoFecha(new Date());
    }
  }

  guardarTorneo() {
    this.loading = true;
    this.nuevoTorneo.fecha = new Date(this.formattedDate);
    this.guardar.emit(this.nuevoTorneo);
  }

  cancelarCreacion() {
    this.cancelar.emit();
  }

  formatoFecha(date: Date): string {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
  }
}
