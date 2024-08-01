import { Component, ElementRef, EventEmitter, Input, OnChanges, Output, SimpleChanges, ViewChild } from '@angular/core';
import { Noticia } from 'src/app/models/noticias';

@Component({
  selector: 'app-create-edit-noticia',
  templateUrl: './create-edit-noticia.component.html',
  styleUrls: ['./create-edit-noticia.component.css']
})
export class CreateEditNoticiaComponent implements OnChanges {
  @ViewChild('fileInput') fileInput?: ElementRef<HTMLInputElement>;
  loading = false;
  selectedFileName?: string;
  imageExists = false;
  imageFirst = false;

  @Input() noticia: Noticia | null = null;
  nuevaNoticia: Noticia = new Noticia();
  formattedDate: string = this.formatoFecha(new Date());

  @Output() guardar = new EventEmitter<Noticia>();
  @Output() cancelar = new EventEmitter<void>();

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['noticia'] && changes['noticia'].currentValue) {
      this.nuevaNoticia = { ...changes['noticia'].currentValue };
      this.formattedDate = this.formatoFecha(new Date(this.nuevaNoticia.fecha));
      if (this.nuevaNoticia.idImagen) {
        this.imageExists = true;
        this.imageFirst = true;
      }
    } else {
      this.nuevaNoticia = new Noticia();
      this.formattedDate = this.formatoFecha(new Date());
    }
  }

  guardarNoticia() {
    this.loading = true;
    this.nuevaNoticia.fecha = new Date(this.formattedDate);
    if (this.nuevaNoticia.idImagen && this.imageFirst) {
      this.nuevaNoticia.idImagen = 'UPDATE';
    }
    this.guardar.emit(this.nuevaNoticia);
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

  imagenSeleccionada(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];
      this.selectedFileName = file.name;
      this.imageExists = true;
      this.convertirAByte(file);
      this.imageFirst = false;
    }
  }

  convertirAByte(file: File): void {
    const reader = new FileReader();
    reader.onload = () => {
      const image = reader.result as string;
      const base64Data = image.split(',')[1];
      this.nuevaNoticia.idImagen = base64Data;
    };
    reader.readAsDataURL(file);
  }

  triggerFileInput(): void {
    if (this.fileInput) {
      this.fileInput.nativeElement.click();
    }
  }

  eliminarImagen(): void {
    this.imageExists = false;
    this.selectedFileName = undefined;
    this.nuevaNoticia.idImagen = 'DELETE';
    this.imageFirst = false;
  }
}