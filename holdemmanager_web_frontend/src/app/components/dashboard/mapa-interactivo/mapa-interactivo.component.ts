import { Component, ElementRef, Renderer2, HostListener, AfterViewInit } from '@angular/core';
import html2canvas from 'html2canvas';

interface PlanoItem {
  type: 'mesa' | 'barra' | 'banio' | 'caja' | 'marketing';
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
export class MapaInteractivoComponent implements AfterViewInit {
  isCreateItem = false;
  newItemType: PlanoItem['type'] = 'mesa';

  itemsOriginales: PlanoItem[] = [
    { type: 'barra', label: 'Barra', x: 55.5, y: 60, rotation: 90 },
    { type: 'banio', label: 'Baños', x: 46, y: 91.5, rotation: 0 },
    { type: 'caja', label: 'Cajas', x: 50, y: 2, rotation: 0 },
    { type: 'marketing', label: 'Marketing', x: 37, y: 2, rotation: 0 }
  ];

  items: PlanoItem[] = JSON.parse(JSON.stringify(this.itemsOriginales));

  private currentItemDragging: PlanoItem | null = null;
  private mouseMovimientoListener: (() => void) | null = null;
  private mouseArribaListener: (() => void) | null = null;
  private leftMouseDown = false;

  constructor(private renderer: Renderer2, private el: ElementRef) { }

  ngAfterViewInit() {
    this.actualizarItemsPosicion();
  }

  @HostListener('window:resize')
  onResize() {
    this.actualizarItemsPosicion();
  }

  empezarArrastrar(event: MouseEvent, item: PlanoItem) {
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

    const mouseMovimiento = (moveEvent: MouseEvent) => {
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

    const mouseArriba = () => {
      this.leftMouseDown = false;
      this.currentItemDragging = null;

      if (this.mouseMovimientoListener) {
        this.mouseMovimientoListener();
      }
      if (this.mouseArribaListener) {
        this.mouseArribaListener();
      }
    };

    this.mouseMovimientoListener = this.renderer.listen('window', 'mousemove', mouseMovimiento);
    this.mouseArribaListener = this.renderer.listen('window', 'mouseup', mouseArriba);
  }

  empezarRotar(event: MouseEvent, item: PlanoItem) {
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

  manejarContextMenu(event: MouseEvent) {
    if (this.leftMouseDown || this.currentItemDragging) {
      event.preventDefault();
    }
  }

  exportarImagen() {
    const container = this.el.nativeElement.querySelector('#plano-container');

    this.actualizarItemsPosicion();

    setTimeout(() => {
      html2canvas(container, {
        useCORS: true,
        allowTaint: true
      }).then((canvas) => {
        const link = document.createElement('a');
        link.href = canvas.toDataURL('image/png');
        link.download = 'plano-torneo.png';
        link.click();
      });
    }, 100);
  }

  reinicarItems() {
    this.items = JSON.parse(JSON.stringify(this.itemsOriginales));
    this.actualizarItemsPosicion();
  }

  nuevoItem() {
    this.isCreateItem = true;
    this.actualizarItemsPosicion();
  }

  guardarNuevoItem(nuevoItem: PlanoItem) {
    const item: PlanoItem = {
      type: nuevoItem.type,
      label: nuevoItem.label,
      x: 10,
      y: 10,
      rotation: 0
    };

    this.items.push(item);
    this.isCreateItem = false;
  }

  cancelarNuevoItem() {
    this.isCreateItem = false;
  }

  actualizarItemsPosicion() {
    const container = this.el.nativeElement.querySelector('#plano-container');
    const containerWidth = container.offsetWidth;
    const containerHeight = container.offsetHeight;

    this.items.forEach(item => {
      const itemElement = this.el.nativeElement.querySelector(`.${item.label}`);
      if (itemElement) {
        this.renderer.setStyle(itemElement, 'left', `${item.x}%`);
        this.renderer.setStyle(itemElement, 'top', `${item.y}%`);
        this.renderer.setStyle(itemElement, 'transform', `rotate(${item.rotation}deg)`);
        if (item.rotation % 180 !== 0) {
          this.renderer.setStyle(itemElement, 'writing-mode', 'vertical-rl');
        } else {
          this.renderer.removeStyle(itemElement, 'writing-mode');
        }
      }
    });
  }
}