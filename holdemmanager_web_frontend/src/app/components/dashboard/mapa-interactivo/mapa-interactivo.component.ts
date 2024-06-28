import { Component, ElementRef, Renderer2, HostListener, AfterViewInit } from '@angular/core';
import html2canvas from 'html2canvas';

interface PlanoItem {
  type: 'mesa' | 'barra' | 'banio' | 'caja' | 'marketing' | 'agua' | 'prensa' | 'infotorneos' | 'espaciador' ;
  label: string;
  x: number;
  y: number;
  rotation: number;
  plano: number;
}

interface Plano {
  id: number;
  nombre: string;
  items: PlanoItem[];
  imagen: string;
}

@Component({
  selector: 'app-mapa-interactivo',
  templateUrl: './mapa-interactivo.component.html',
  styleUrls: ['./mapa-interactivo.component.css']
})
export class MapaInteractivoComponent implements AfterViewInit {
  currentPlanoId: number = 1;
  isCreateItem = false;
  newItemType: PlanoItem['type'] = 'mesa';

  planos: Plano[] = [
    {
      id: 1,
      nombre: 'Plano del Torneo',
      items: [],
      imagen: 'assets/images/plano1.png'
    },
    {
      id: 2,
      nombre: 'Sala de Torneo',
      items: [],
      imagen: 'assets/images/plano2.png'
    }
  ];

  itemsOriginales: PlanoItem[] = [
    { type: 'barra', label: 'Barra', x: 55.5, y: 60, rotation: 90, plano: 1 },
    { type: 'banio', label: 'Baños', x: 46, y: 91.5, rotation: 0, plano: 1 },
    { type: 'caja', label: 'Cajas', x: 50, y: 2, rotation: 0, plano: 1 },
    { type: 'marketing', label: 'Marketing', x: 37, y: 2, rotation: 0, plano: 1 },
    { type: 'infotorneos', label: 'Información Torneos', x: 88.2, y: 87, rotation: 0, plano: 2 },
    { type: 'prensa', label: 'Prensa', x: 91, y: 20, rotation: 90, plano: 2 },
    { type: 'agua', label: '', x: 31, y: 2, rotation: 0, plano: 2 },
    { type: 'agua', label: '', x: 61, y: 2, rotation: 0, plano: 2 },
    { type: 'agua', label: '', x: 31, y: 93, rotation: 0, plano: 2 },
    { type: 'agua', label: '', x: 61, y: 93, rotation: 0, plano: 2 },
    ...this.crearMesasManuales()
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
    html2canvas(container, {
      useCORS: true,
      allowTaint: true
    }).then((canvas) => {
      const link = document.createElement('a');
      link.href = canvas.toDataURL('image/png');
      link.download = 'plano-torneo.png';
      link.click();
    });
  }

  reinicarItems() {
    this.items = JSON.parse(JSON.stringify(this.itemsOriginales));
    this.actualizarItemsPosicion();
  }

  nuevoItem() {
    this.isCreateItem = true;
  }

  guardarNuevoItem(nuevoItem: PlanoItem) {
    const item: PlanoItem = {
      ...nuevoItem,
      x: 10,
      y: 10,
      rotation: 0,
      plano: this.currentPlanoId,
    };

    this.items.push(item);
    this.planos.find(plano => plano.id === this.currentPlanoId)?.items.push(item);
    this.isCreateItem = false;
  }

  cancelarNuevoItem() {
    this.isCreateItem = false;
  }

  actualizarItemsPosicion() {
    const container = this.el.nativeElement.querySelector('#plano-container');
    const containerWidth = container.offsetWidth;
    const containerHeight = container.offsetHeight;

    this.items.filter(i => i.plano === this.currentPlanoId).forEach(item => {
      const itemElement = this.el.nativeElement.querySelector(`.${item.type}`);
      if (itemElement) {
        this.renderer.setStyle(itemElement, 'left', `${item.x}%`);
        this.renderer.setStyle(itemElement, 'top', `${item.y}%`);
        this.renderer.setStyle(itemElement, 'transform', `rotate(${item.rotation}deg)`);
        if (item.rotation % 180 !== 0) {
          this.renderer.setStyle(itemElement, 'writing-mode', 'vertical');
        } else {
          this.renderer.removeStyle(itemElement, 'writing-mode');
        }
      }
    });
  }

  get currentPlano(): Plano {
    return this.planos.find(plano => plano.id === this.currentPlanoId)!;
  }

  cambiarPlano(event: Event) {
    const selectElement = event.target as HTMLSelectElement;
    this.currentPlanoId = Number(selectElement.value);
    this.actualizarItemsPosicion();
  }

  get itemsFiltrados(): PlanoItem[] {
    return this.items.filter(i => i.plano === this.currentPlanoId);
  }

  crearMesasManuales(): PlanoItem[] {
    return [
      { type: 'mesa', label: 'Mesa 1', x: 77, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 2', x: 77, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 3', x: 77, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 4', x: 77, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 5', x: 77, y: 74, rotation: 270, plano: 2 },
  
      { type: 'mesa', label: 'Mesa 6', x: 69, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 7', x: 69, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 8', x: 69, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 9', x: 69, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 10', x: 69, y: 74, rotation: 270, plano: 2 },

      { type: 'mesa', label: 'Mesa 11', x: 61, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 12', x: 61, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 13', x: 61, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 14', x: 61, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 15', x: 61, y: 74, rotation: 270, plano: 2 },

      { type: 'mesa', label: 'Mesa 16', x: 53, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 17', x: 53, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 18', x: 53, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 19', x: 53, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 20', x: 53, y: 74, rotation: 270, plano: 2 },

      { type: 'mesa', label: 'Mesa 21', x: 45, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 22', x: 45, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 23', x: 45, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 24', x: 45, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 25', x: 45, y: 74, rotation: 270, plano: 2 },

      { type: 'mesa', label: 'Mesa 26', x: 33, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 27', x: 33, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 28', x: 33, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 29', x: 33, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 30', x: 33, y: 74, rotation: 270, plano: 2 },

      { type: 'mesa', label: 'Mesa 31', x: 25, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 32', x: 25, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 33', x: 25, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 34', x: 25, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 35', x: 25, y: 74, rotation: 270, plano: 2 },

      { type: 'mesa', label: 'Mesa 36', x: 17, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 37', x: 17, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 38', x: 17, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 39', x: 17, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 40', x: 17, y: 74, rotation: 270, plano: 2 },

      { type: 'mesa', label: 'Mesa 41', x: 9, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 42', x: 9, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 43', x: 9, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 44', x: 9, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 45', x: 9, y: 74, rotation: 270, plano: 2 },

      { type: 'mesa', label: 'Mesa 46', x: 1, y: 14, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 47', x: 1, y: 29, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 48', x: 1, y: 44, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 49', x: 1, y: 59, rotation: 270, plano: 2 },
      { type: 'mesa', label: 'Mesa 50', x: 1, y: 74, rotation: 270, plano: 2 },
  
      { type: 'mesa', label: 'Mesa Final', x: 88, y: 43, rotation: 90, plano: 2 },
    ];
  }
}
