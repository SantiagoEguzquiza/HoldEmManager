import { Component, ElementRef, Renderer2, HostListener } from '@angular/core';
import html2canvas from 'html2canvas';

interface PlanoItem {
  type: 'mesa' | 'barra' | 'banio'| 'caja'| 'marketing';
  label: string;
  x: number;  // En porcentaje
  y: number;  // En porcentaje
  rotation: number;
}

@Component({
  selector: 'app-mapa-interactivo',
  templateUrl: './mapa-interactivo.component.html',
  styleUrls: ['./mapa-interactivo.component.css']
})
export class MapaInteractivoComponent {
  itemsOriginales: PlanoItem[] = [
    { type: 'mesa', label: 'Mesa 1', x: 67, y: 25, rotation: 0 },
    { type: 'mesa', label: 'Mesa 2', x: 67, y: 35, rotation: 0 },
    { type: 'barra', label: 'Barra', x: 49.9, y: 34, rotation: 90 },
    { type: 'banio', label: 'Baños', x: 41, y: 52, rotation: 0 },
    { type: 'caja', label: 'Cajas', x: 25, y: 30, rotation: 0 },
    { type: 'marketing', label: 'Marketing', x: 10, y: 30, rotation: 0 }
  ];

  items: PlanoItem[] = [...this.itemsOriginales];

  private currentItemDragging: PlanoItem | null = null;
  private mouseMoveListener: (() => void) | null = null;
  private mouseUpListener: (() => void) | null = null;
  private leftMouseDown = false;

  constructor(private renderer: Renderer2, private el: ElementRef) {}

  @HostListener('window:resize')
  onResize() {
    this.updateItemPositions();
  }

  startDrag(event: MouseEvent, item: PlanoItem) {
    event.preventDefault();
    const container = this.el.nativeElement.querySelector('#plano-container');
    const containerWidth = container.offsetWidth;
    const containerHeight = container.offsetHeight;
    const startX = event.clientX;
    const startY = event.clientY;
    const initX = (item.x / 100) * containerWidth;
    const initY = (item.y / 100) * containerHeight;

    if (this.currentItemDragging) {
      return;
    }

    this.leftMouseDown = true;
    this.currentItemDragging = item;

    const mouseMove = (moveEvent: MouseEvent) => {
      if (!this.leftMouseDown || !this.currentItemDragging) {
        return;
      }
      const dx = moveEvent.clientX - startX;
      const dy = moveEvent.clientY - startY;
      const newX = initX + dx;
      const newY = initY + dy;
      this.currentItemDragging.x = (newX / containerWidth) * 100;
      this.currentItemDragging.y = (newY / containerHeight) * 100;
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
    this.items = [...this.itemsOriginales];
    this.updateItemPositions();
  }

  updateItemPositions() {
    const container = this.el.nativeElement.querySelector('#plano-container');
    const containerWidth = container.offsetWidth;
    const containerHeight = container.offsetHeight;

    this.items.forEach(item => {
      const itemElement = this.el.nativeElement.querySelector(`.${item.label}`);
      if (itemElement) {
        this.renderer.setStyle(itemElement, 'left', `${item.x}%`);
        this.renderer.setStyle(itemElement, 'top', `${item.y}%`);
        this.renderer.setStyle(itemElement, 'transform', `rotate(${item.rotation}deg)`);
      }
    });
  }
}
