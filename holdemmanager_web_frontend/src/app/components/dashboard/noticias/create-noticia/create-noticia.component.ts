import { Component, EventEmitter, Output } from '@angular/core';

interface Noticia {
  id: number;
  titulo: string;
  fecha: Date;
  mensaje: string;
  URLImagen?: string;
}

@Component({
  selector: 'app-create-noticia',
  templateUrl: './create-noticia.component.html',
  styleUrls: ['./create-noticia.component.css']
})
export class CreateNoticiaComponent {
  nuevaNoticia: Noticia = {
    id: 0,
    titulo: '',
    fecha: new Date(),
    mensaje: '',
    URLImagen: ''
  };

  @Output() guardar = new EventEmitter<Noticia>();
  @Output() cancelar = new EventEmitter<void>();


  guardarNoticia() {
    this.guardar.emit(this.nuevaNoticia);
  }

  cancelarCreacion() {
    this.cancelar.emit();
  }

}
