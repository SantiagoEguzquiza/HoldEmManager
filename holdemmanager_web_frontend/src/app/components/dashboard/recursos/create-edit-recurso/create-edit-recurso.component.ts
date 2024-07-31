import { Component, OnInit, ViewChild, ElementRef, Input, Output, EventEmitter, OnChanges, SimpleChanges } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { youtubeUrlValidator } from 'src/app/helpers/youtube-url.validator';
import { RecursoEducativo } from 'src/app/models/recursos';

@Component({
  selector: 'app-create-edit-recurso',
  templateUrl: './create-edit-recurso.component.html',
  styleUrls: ['./create-edit-recurso.component.css']
})
export class CreateEditRecursoComponent implements OnInit, OnChanges {
  @ViewChild('fileInput') fileInput?: ElementRef<HTMLInputElement>;
  @Input() recurso: RecursoEducativo | null = null;
  @Output() guardar = new EventEmitter<RecursoEducativo>();
  @Output() cancelar = new EventEmitter<void>();

  recursoForm!: FormGroup;
  loading = false;
  selectedFileName?: string;
  imageExists = false;
  imageFirst = false;

  constructor(private fb: FormBuilder) {}

  ngOnInit(): void {
    this.initializeForm();
    if (this.recurso) {
      this.recursoForm.patchValue(this.recurso);
      if (this.recurso.urlImagen) {
        this.imageExists = true;
        this.imageFirst = true;
      }
    }
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['recurso'] && changes['recurso'].currentValue) {
      if (!this.recursoForm) {
        this.initializeForm();
      }
      this.recursoForm.patchValue(changes['recurso'].currentValue);
      if (changes['recurso'].currentValue.urlImagen) {
        this.imageExists = true;
      }
    }
  }

  private initializeForm(): void {
    this.recursoForm = this.fb.group({
      id: [null],
      titulo: ['', Validators.required],
      mensaje: ['', Validators.required],
      urlVideo: ['', [youtubeUrlValidator()]],
      urlImagen: ['']
    });
  }

  guardarRecurso() {
    if (this.recursoForm.valid) {
      this.loading = true;
      const nuevoRecurso = this.recursoForm.value;
  
      if (nuevoRecurso.urlImagen && this.imageFirst) {
        nuevoRecurso.urlImagen = 'UPDATE';
      }
  
      if (this.recurso) {
        nuevoRecurso.id = this.recurso.id;
      }
      this.guardar.emit(nuevoRecurso);
    } else {
      alert('Por favor, corrige los errores en el formulario.');
    }
  }

  cancelarCreacion() {
    this.cancelar.emit();
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
      this.recursoForm.patchValue({ urlImagen: base64Data });
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
    this.recursoForm.patchValue({ urlImagen: 'DELETE' });
    this.imageFirst = false;
  }
}