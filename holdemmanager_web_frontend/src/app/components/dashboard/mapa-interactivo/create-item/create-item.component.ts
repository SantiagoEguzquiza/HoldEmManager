import { Component, EventEmitter, Output } from '@angular/core';

interface PlanoItem {
  type: 'mesa' | 'barra' | 'banio' | 'caja' | 'marketing' | 'agua' | 'espaciador' | 'infotorneos';
  label: string;
  x: number;
  y: number;
  rotation: number;
  plano: number;
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
    rotation: 0,
    plano: 1,
  };

  @Output() guardar = new EventEmitter<PlanoItem>();
  @Output() cancelar = new EventEmitter<void>();

  tiposItems: { tipo: 'mesa' | 'barra' | 'banio' | 'caja' | 'marketing' | 'agua' | 'espaciador' | 'infotorneos'| 'barbero'| 'entretenimiento', nombre: string }[] = [
    { tipo: 'mesa', nombre: 'Mesa' },
    { tipo: 'barra', nombre: 'Barra' },
    { tipo: 'banio', nombre: 'Baño' },
    { tipo: 'caja', nombre: 'Caja' },
    { tipo: 'marketing', nombre: 'Marketing' },
    { tipo: 'agua', nombre: 'Agua' },
    { tipo: 'espaciador', nombre: 'Espaciador' },
    { tipo: 'infotorneos', nombre: 'Información Torneos' },
    { tipo: 'barbero', nombre: 'Barbero' },
    { tipo: 'entretenimiento', nombre: 'Entretenimiento' }
  ];

  guardarItem() {
    var nombre = this.nuevoItem.type.toString();
    
    if (nombre === 'espaciador' || nombre === 'agua') {
      this.nuevoItem.label = '';
    }
    this.guardar.emit(this.nuevoItem);
  }

  cancelarItem() {
    this.cancelar.emit();
  }
}