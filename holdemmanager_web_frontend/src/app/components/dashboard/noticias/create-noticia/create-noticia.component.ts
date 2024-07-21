import { Component, EventEmitter, Input, OnChanges, Output, SimpleChanges } from '@angular/core';

interface Noticia {
  id?: number;
  titulo: string;
  fecha: Date;
  mensaje: string;
  urlImagen?: string;
}

@Component({
  selector: 'app-create-noticia',
  templateUrl: './create-noticia.component.html',
  styleUrls: ['./create-noticia.component.css']
})
export class CreateNoticiaComponent implements OnChanges {
  @Input() noticia: Noticia | null = null;
  nuevaNoticia: Noticia = {
    id: 0,
    titulo: '',
    fecha: new Date(),
    mensaje: '',
    urlImagen: ''
  };

  @Output() guardar = new EventEmitter<Noticia>();
  @Output() cancelar = new EventEmitter<void>();

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['noticia'] && this.noticia) {
      this.nuevaNoticia = { ...this.noticia };
    }
  }

  guardarNoticia() {
    this.guardar.emit(this.nuevaNoticia);
  }

  cancelarCreacion() {
    this.cancelar.emit();
  }
}
