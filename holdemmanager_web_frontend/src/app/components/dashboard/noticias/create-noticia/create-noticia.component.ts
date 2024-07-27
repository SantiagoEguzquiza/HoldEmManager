import { Component, ElementRef, EventEmitter, Input, OnChanges, Output, SimpleChanges, ViewChild } from '@angular/core';
import { Noticia } from 'src/app/models/noticias';

@Component({
  selector: 'app-create-noticia',
  templateUrl: './create-noticia.component.html',
  styleUrls: ['./create-noticia.component.css']
})
export class CreateNoticiaComponent implements OnChanges {
  @ViewChild('fileInput') fileInput?: ElementRef;
  loading = false;
  selectedFile?: File;
  selectedFileName?: string;

  @Input() noticia: Noticia | null = null;
  nuevaNoticia: Noticia = new Noticia();
  formattedDate: string = this.formatoFecha(new Date());

  @Output() guardar = new EventEmitter<Noticia>();
  @Output() cancelar = new EventEmitter<void>();

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['noticia'] && changes['noticia'].currentValue !== null && changes['noticia'].currentValue !== undefined) {
      this.nuevaNoticia = { ...changes['noticia'].currentValue };
      this.formattedDate = this.formatoFecha(new Date(this.nuevaNoticia.fecha));
    } else {
      this.nuevaNoticia = new Noticia();
      this.formattedDate = this.formatoFecha(new Date());
    }
  }

  guardarNoticia() {
    this.loading = true;
    this.nuevaNoticia.fecha = new Date(this.formattedDate);
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

  imagenSeleccionada(event: any): void {
    this.selectedFile = event.target.files[0];
    this.selectedFileName = this.selectedFile ? this.selectedFile.name : '';

    if (this.selectedFile) {
      this.convertirAByte(this.selectedFile);
    }
  }

  convertirAByte(file: File): void {
    const reader = new FileReader();
    reader.onload = (e) => {
      const image = reader.result as string;
      const base64Data = image.split(',')[1];
      this.nuevaNoticia.idImagen = base64Data;
    };
    reader.readAsDataURL(file);

  }

  triggerFileInput(): void {
    this.fileInput!.nativeElement.click();
  }
}