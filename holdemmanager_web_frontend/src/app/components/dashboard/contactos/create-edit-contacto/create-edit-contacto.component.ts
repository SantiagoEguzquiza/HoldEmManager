import { Component, ElementRef, EventEmitter, Input, OnChanges, Output, SimpleChanges, ViewChild } from '@angular/core';
import { Contacto } from 'src/app/models/contactos';

@Component({
  selector: 'app-create-edit-contacto',
  templateUrl: './create-edit-contacto.component.html',
  styleUrls: ['./create-edit-contacto.component.css']
})
export class CreateEditContactoComponent implements OnChanges {
  @ViewChild('fileInput') fileInput?: ElementRef<HTMLInputElement>;
  loading = false;

  @Input() contacto: Contacto | null = null;
  nuevoContacto: Contacto = new Contacto();

  @Output() guardar = new EventEmitter<Contacto>();
  @Output() cancelar = new EventEmitter<void>();

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['contacto'] && changes['contacto'].currentValue) {
      this.nuevoContacto = { ...changes['contacto'].currentValue };
    } else {
      this.nuevoContacto = new Contacto();
    }
  }

  guardarContacto(): void {
    this.loading = true;
    this.guardar.emit(this.nuevoContacto);
  }

  cancelarCreacion() {
    this.cancelar.emit();
  }
}
