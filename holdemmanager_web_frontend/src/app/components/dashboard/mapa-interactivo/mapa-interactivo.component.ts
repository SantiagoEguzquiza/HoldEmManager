import { Component, ElementRef, Renderer2 } from '@angular/core';
import html2canvas from 'html2canvas';

interface PlanoItem {
  type: 'mesa' | 'barra' | 'banio'| 'caja'| 'recHumanos';
  label: string;
  x: number;
  y: number;
  rotation: number;
}

@Component({
  selector: 'app-mapa-interactivo',
  templateUrl: './mapa-interactivo.component.html',
  styleUrls: ['./mapa-interactivo.component.css']
})
export class MapaInteractivoComponent {
  itemsOriginales: PlanoItem[] = [
    { type: 'mesa', label: 'Mesa 1', x: 100, y: 200, rotation: 0 },
    { type: 'mesa', label: 'Mesa 2', x: 150, y: 250, rotation: 0 },
    { type: 'barra', label: 'Barra', x: 300, y: 100, rotation: 0 },
    { type: 'banio', label: 'Baños', x: 200, y: 300, rotation: 0 },
    { type: 'caja', label: 'Cajas', x: 250, y: 300, rotation: 0 },
    { type: 'recHumanos', label: 'Recursos Humanos', x: 100, y: 300, rotation: 0 }
  ];

  items: PlanoItem[] = [
    { type: 'mesa', label: 'Mesa 1', x: 670, y: 250, rotation: 0 },
    { type: 'mesa', label: 'Mesa 2', x: 670, y: 350, rotation: 0 },
    { type: 'barra', label: 'Barra', x: 499, y: 340, rotation: 90 },
    { type: 'banio', label: 'Baños', x: 410, y: 520, rotation: 0 },
    { type: 'caja', label: 'Cajas', x: 250, y: 300, rotation: 0 },
    { type: 'recHumanos', label: 'Recursos Humanos', x: 100, y: 300, rotation: 0 }
  ];

  private mouseMoveListener: (() => void) | null = null;
  private mouseUpListener: (() => void) | null = null;
  private contextMenuListener: (() => void) | null = null;
  private leftMouseDown = false;
  private currentItemDragging: PlanoItem | null = null;

  constructor(private renderer: Renderer2, private el: ElementRef) {}

  startDrag(event: MouseEvent, item: PlanoItem) {
    event.preventDefault();
    const startX = event.clientX;
    const startY = event.clientY;
    const initX = item.x;
    const initY = item.y;

    // Verificar si ya hay un item moviéndose
    if (this.currentItemDragging) {
      return;
    }

    this.leftMouseDown = true;
    this.currentItemDragging = item;

    // Eliminar el listener de contextmenu si existe para evitar conflictos
    if (this.contextMenuListener) {
      this.contextMenuListener();
      this.contextMenuListener = null;
    }

    const mouseMove = (moveEvent: MouseEvent) => {
      if (!this.leftMouseDown || !this.currentItemDragging) {
        return;
      }
      const dx = moveEvent.clientX - startX;
      const dy = moveEvent.clientY - startY;
      this.currentItemDragging.x = initX + dx;
      this.currentItemDragging.y = initY + dy;
    };

    const mouseUp = () => {
      this.leftMouseDown = false;
      this.currentItemDragging = null;

      if (this.mouseMoveListener) {
        this.mouseMoveListener();
      }
      if (this.mouseUpListener) {
        this.mouseUpListener();
      }
    };

    this.mouseMoveListener = this.renderer.listen('window', 'mousemove', mouseMove);
    this.mouseUpListener = this.renderer.listen('window', 'mouseup', mouseUp);
  }

  startRotate(event: MouseEvent, item: PlanoItem) {
    event.preventDefault();
    if (this.leftMouseDown || this.currentItemDragging) {
      return;
    }

    item.rotation += 90;
    item.rotation = item.rotation % 360;
    if (item.rotation < 0) {
      item.rotation += 360;
    }
  }

  handleContextMenu(event: MouseEvent) {
    if (this.leftMouseDown || this.currentItemDragging) {
      event.preventDefault();
    }
  }

  exportAsImage() {
    const container = this.el.nativeElement.querySelector('#plano-container');
    html2canvas(container).then((canvas) => {
      const link = document.createElement('a');
      link.href = canvas.toDataURL('image/png');
      link.download = 'plano-torneo.png';
      link.click();
    });
  }

  resetItems() {
    this.items = this.itemsOriginales.map(item => ({
      ...item,
      rotation: 0
    }));
  }

}