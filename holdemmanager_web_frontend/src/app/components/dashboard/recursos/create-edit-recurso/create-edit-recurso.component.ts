import { ChangeDetectorRef, Component, ElementRef, EventEmitter, Input, OnChanges, Output, SimpleChanges, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { RecursoEducativo } from 'src/app/models/recursos';
import { youtubeUrlValidator } from '../../../../helpers/youtube-url.validator';

@Component({
  selector: 'app-create-edit-recurso',
  templateUrl: './create-edit-recurso.component.html',
  styleUrls: ['./create-edit-recurso.component.css']
})
export class CreateEditRecursoComponent implements OnChanges {
  @ViewChild('fileInput') fileInput?: ElementRef<HTMLInputElement>;
  loading = false;
  selectedFileName?: string;
  imageExists = false;
  imageFirst = false;
  imagenRequerida = false;
  imagenValida = false;

  @Input() recurso: RecursoEducativo | null = null;
  nuevoRecurso: RecursoEducativo = new RecursoEducativo();
  recursoForm: FormGroup;

  @Output() guardar = new EventEmitter<RecursoEducativo>();
  @Output() cancelar = new EventEmitter<void>();

  constructor(private toastr: ToastrService, private fb: FormBuilder, private cdr: ChangeDetectorRef) {
    this.recursoForm = this.fb.group({
      titulo: ['', Validators.required],
      mensaje: ['', Validators.required],
      urlVideo: ['', [youtubeUrlValidator()]],
      imagen: ''
    });
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['recurso'] && changes['recurso'].currentValue) {
      this.nuevoRecurso = { ...changes['recurso'].currentValue };

      this.recursoForm.patchValue({
        titulo: this.nuevoRecurso.titulo,
        mensaje: this.nuevoRecurso.mensaje,
        urlVideo: this.nuevoRecurso.urlVideo
      });

      if (this.nuevoRecurso.urlImagen) {        
        this.imageExists = true;
        this.imageFirst = true;
        this.imagenValida = true;

        this.cdr.detectChanges();

        if (this.fileInput) {
          this.fileInput.nativeElement.disabled = true;
        }
      } else {
        this.imagenValida = false;
      }
    } else {
      this.nuevoRecurso = new RecursoEducativo();
      this.recursoForm.reset();
      this.imagenValida = false;
    }
  }

  guardarRecurso() {
    this.nuevoRecurso.titulo = this.recursoForm.get('titulo')?.value;
    this.nuevoRecurso.mensaje = this.recursoForm.get('mensaje')?.value;
    this.nuevoRecurso.urlVideo = this.recursoForm.get('urlVideo')?.value;

    if (this.recursoForm.invalid || !this.imagenValida) {
      return;
    }

    if (!this.nuevoRecurso.urlImagen || this.nuevoRecurso.urlImagen === 'DELETE') {
      this.imagenRequerida = true;
      this.imagenValida = false;
      return;
    }

    this.loading = true;
    if (this.nuevoRecurso.urlImagen && this.imageFirst) {
      this.nuevoRecurso.urlImagen = 'UPDATE';
    }
    this.guardar.emit(this.nuevoRecurso);
  }

  cancelarCreacion() {
    this.cancelar.emit();
  }

  imagenSeleccionada(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];
      const fileType = file.type;

      if (!fileType.startsWith('image/')) {
        this.toastr.error('Por favor, seleccione un archivo de imagen válido.', 'Archivo no válido');
        this.resetFileInput();
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

  eliminarImagen(): void {
    this.imageExists = false;
    this.selectedFileName = undefined;
    this.nuevoRecurso.urlImagen = 'DELETE';
    this.imageFirst = false;
    this.imagenRequerida = true;
    this.imagenValida = false;

    if (this.fileInput) {
      this.fileInput.nativeElement.value = '';
      this.fileInput.nativeElement.disabled = false;
    }
  }

  convertirAByte(file: File): void {
    const reader = new FileReader();
    reader.onload = () => {
      const img = new Image();
      img.src = reader.result as string;
      img.onload = () => {
        const canvas = document.createElement('canvas');
        const maxWidth = 800;
        const scaleSize = maxWidth / img.width;
        canvas.width = maxWidth;
        canvas.height = img.height * scaleSize;
        const ctx = canvas.getContext('2d');
        ctx?.drawImage(img, 0, 0, canvas.width, canvas.height);
        const optimizedImage = canvas.toDataURL('image/jpeg', 0.7);
        const base64Data = optimizedImage.split(',')[1];
        this.nuevoRecurso.urlImagen = base64Data;
      };
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

  resetFileInput(): void {
    if (this.fileInput) {
      this.fileInput.nativeElement.value = '';
    }
    this.imageExists = false;
    this.imagenRequerida = true;
    this.imagenValida = false;
  }
}