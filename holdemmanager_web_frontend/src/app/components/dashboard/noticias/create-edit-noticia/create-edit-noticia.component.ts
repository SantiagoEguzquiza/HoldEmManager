import { Component, ElementRef, EventEmitter, Input, OnChanges, Output, SimpleChanges, ViewChild } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
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
  imagenRequerida = false;
  imagenValida = false;

  @Input() noticia: Noticia | null = null;
  nuevaNoticia: Noticia = new Noticia();
  formattedDate: string = this.formatoFecha(new Date());

  @Output() guardar = new EventEmitter<Noticia>();
  @Output() cancelar = new EventEmitter<void>();
  
  constructor(private toastr: ToastrService) { }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['noticia'] && changes['noticia'].currentValue) {
      this.nuevaNoticia = { ...changes['noticia'].currentValue };
      this.formattedDate = this.formatoFecha(new Date(this.nuevaNoticia.fecha));
      if (this.nuevaNoticia.idImagen) {
        this.imageExists = true;
        this.imageFirst = true;
        if (this.fileInput) {
          this.fileInput.nativeElement.disabled = true;
        }
      }
    } else {
      this.nuevaNoticia = new Noticia();
      this.formattedDate = this.formatoFecha(new Date());
    }
  }

  guardarNoticia() {
    if (!this.nuevaNoticia.idImagen || this.nuevaNoticia.idImagen === 'DELETE') {
      this.imagenRequerida = true;
      this.imagenValida = false;
      return;
    }
  
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
      const fileType = file.type;
  
      if (!fileType.startsWith('image/')) {
        this.toastr.error('Por favor, seleccione un archivo de imagen válido.', 'Archivo no válido');
        
        if (this.fileInput) {
          this.fileInput.nativeElement.value = '';
        }
        
        this.imageExists = false;
        this.imagenRequerida = true;
        this.imagenValida = false;
        return;
      }
  
      this.selectedFileName = file.name;
      this.imageExists = true;
      this.convertirAByte(file);
      this.imageFirst = false;
      this.imagenRequerida = false;  
      this.imagenValida = true;
      if (this.fileInput) {
        this.fileInput.nativeElement.disabled = true;
      }
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
    this.imagenRequerida = true;
    if (this.fileInput) {
      this.fileInput.nativeElement.value = '';
      this.fileInput.nativeElement.click();
    }
  }

  eliminarImagen(): void {
    this.imageExists = false;
    this.selectedFileName = undefined;
    this.nuevaNoticia.idImagen = 'DELETE';
    this.imageFirst = false;
    this.imagenRequerida = true;  
    this.imagenValida = false;
    
    if (this.fileInput) {
      this.fileInput.nativeElement.value = '';
      this.fileInput.nativeElement.disabled = false;
    }
  }
}