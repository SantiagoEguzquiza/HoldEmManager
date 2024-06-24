import { Component, EventEmitter, Output } from '@angular/core';

interface PlanoItem {
  type: 'mesa' | 'barra' | 'banio' | 'caja' | 'marketing';
  label: string;
  x: number;
  y: number;
  rotation: number;
}

@Component({
  selector: 'app-create-item',
  templateUrl: './create-item.component.html',
  styleUrls: ['./create-item.component.css']
})
export class CreateItemComponent {
  nuevoItem: PlanoItem = {
    type: 'mesa',
    label: '',
    x: 0,
    y: 0,
    rotation: 0
  };

  @Output() guardar = new EventEmitter<PlanoItem>();
  @Output() cancelar = new EventEmitter<void>();

  tiposItems: { tipo: 'mesa' | 'barra' | 'banio' | 'caja' | 'marketing', nombre: string }[] = [
    { tipo: 'mesa', nombre: 'Mesa' },
    { tipo: 'barra', nombre: 'Barra' },
    { tipo: 'banio', nombre: 'Baño' },
    { tipo: 'caja', nombre: 'Caja' },
    { tipo: 'marketing', nombre: 'Marketing' }
  ];

  guardarItem() {
    this.guardar.emit(this.nuevoItem);
  }

  cancelarItem() {
    this.cancelar.emit();
  }
}