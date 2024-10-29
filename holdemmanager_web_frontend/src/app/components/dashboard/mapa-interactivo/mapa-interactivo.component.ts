import { Component, ElementRef, Renderer2, HostListener, AfterViewInit } from '@angular/core';
import html2canvas from 'html2canvas';
import { ToastrService } from 'ngx-toastr';
import { MapaHelper } from 'src/app/helpers/mapaHelper';
import { MapaService } from 'src/app/service/mapa.service';

interface PlanoItem {
  type: 'mesa' | 'barra' | 'banio' | 'caja' | 'marketing' | 'agua' | 'prensa' | 'infotorneos' | 'espaciador' | 'barbero' | 'entretenimiento' | 'salatorneo';
  label: string;
  x: number;
  y: number;
  rotation: number;
  plano: number;
  width: number;
  height: number;
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
  isHelp = false;
  newItemType: PlanoItem['type'] = 'mesa';
  loading = false;
  private planoContainer: HTMLElement | null = null;

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
    { type: 'banio', label: 'Bathrooms', x: 70, y: 21, rotation: 0, plano: 1, width: 65, height: 40 },
    { type: 'caja', label: 'Cashier', x: 37.7, y: 77, rotation: -90, plano: 1, width: 60, height: 35 },
    { type: 'marketing', label: 'Marketing', x: 36.6, y: 60, rotation: -90, plano: 1, width: 80, height: 35 },
    { type: 'infotorneos', label: 'Tournament Information', x: 90, y: 89.4, rotation: 0, plano: 2, width: 80, height: 50 },
    { type: 'prensa', label: 'Press', x: 92.8, y: 20, rotation: 90, plano: 2, width: 70, height: 40 },
    { type: 'agua', label: '', x: 31, y: 1.7, rotation: 0, plano: 2, width: 20, height: 20 },
    { type: 'agua', label: '', x: 61, y: 1.7, rotation: 0, plano: 2, width: 20, height: 20 },
    { type: 'agua', label: '', x: 31, y: 95, rotation: 0, plano: 2, width: 20, height: 20 },
    { type: 'agua', label: '', x: 61, y: 95, rotation: 0, plano: 2, width: 20, height: 20 },
    { type: 'barbero', label: 'Barber', x: 56.8, y: 65, rotation: 90, plano: 1, width: 50, height: 30 },
    { type: 'entretenimiento', label: 'Entertainment', x: 55.4, y: 73.5, rotation: 90, plano: 1, width: 60, height: 45 },
    ...this.crearMesasManuales()
  ];

  items: PlanoItem[] = JSON.parse(JSON.stringify(this.itemsOriginales));

  private currentItemDragging: PlanoItem | null = null;
  private mouseMovimientoListener: (() => void) | null = null;
  private mouseArribaListener: (() => void) | null = null;
  private leftMouseDown = false;

  constructor(private renderer: Renderer2, private el: ElementRef, private mapaService: MapaService, private toastr: ToastrService) { }

  ngAfterViewInit() {
    this.planoContainer = this.el.nativeElement.querySelector('#plano-container');
    this.actualizarItemsPosicion();
  }

  @HostListener('window:resize')
  onResize() {
    this.actualizarItemsPosicion();
  }

  empezarArrastrar(event: MouseEvent, item: PlanoItem) {
    event.preventDefault();

    if (this.currentItemDragging || event.button !== 0) { 
      return;
    }

    const containerWidth = this.planoContainer!.offsetWidth;
    const containerHeight = this.planoContainer!.offsetHeight;
    const startX = event.clientX;
    const startY = event.clientY;
    const initX = (item.x / 100) * containerWidth;
    const initY = (item.y / 100) * containerHeight;

    this.leftMouseDown = true;
    this.currentItemDragging = item;

    this.mouseMovimientoListener = this.renderer.listen('window', 'mousemove', (moveEvent: MouseEvent) => {
      const dx = moveEvent.clientX - startX;
      const dy = moveEvent.clientY - startY;
      this.currentItemDragging!.x = ((initX + dx) / containerWidth) * 100;
      this.currentItemDragging!.y = ((initY + dy) / containerHeight) * 100;
    });

    this.mouseArribaListener = this.renderer.listen('window', 'mouseup', () => {
      this.leftMouseDown = false;
      this.currentItemDragging = null;
      this.mouseMovimientoListener?.();
      this.mouseArribaListener?.();
    });
  }

  empezarRotar(event: MouseEvent, item: PlanoItem) {
    event.preventDefault();
    if (!this.leftMouseDown && !this.currentItemDragging) {
      item.rotation = (item.rotation + 90) % 360;
    }
  }

  manejarContextMenu(event: MouseEvent) {
    if (this.leftMouseDown || this.currentItemDragging) {
      event.preventDefault();
    }
  }

  exportarImagen(): void {
    html2canvas(this.planoContainer!, {
      useCORS: true,
      allowTaint: true,
      scale: window.devicePixelRatio
    }).then((canvas) => {
      const base64Image = canvas.toDataURL('image/png').split(',')[1];

      const mapa: MapaHelper = {
        planoId: this.currentPlanoId,
        planoString: base64Image
      };

      this.mapaService.saveMapa(mapa).subscribe(data => {
        this.toastr.success(data.message);
      }, (error) => {
        this.loading = false;
        if (error.status != 401) {
          this.toastr.error(error.message, 'Error');
        }
      });
    });
  }

  convertirImagenBytes(base64: string): number[] {
    const binaryString = atob(base64);
    const byteArray = new Array(binaryString.length);
    for (let i = 0; i < binaryString.length; i++) {
      byteArray[i] = binaryString.charCodeAt(i);
    }
    return byteArray;
  }

  reinicarItems() {
    this.items = JSON.parse(JSON.stringify(this.itemsOriginales));
    this.actualizarItemsPosicion();
  }

  nuevoItem() {
    this.isCreateItem = true;
  }

  help() {
    this.isHelp = true;
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

  atrasItem() {
    this.isHelp = false;
  }

  actualizarItemsPosicion() {
    const containerWidth = this.planoContainer!.offsetWidth;
    const containerHeight = this.planoContainer!.offsetHeight;

    this.itemsFiltrados.forEach(item => {
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

  crearMesa(label: string, x: number, y: number, plano: number): PlanoItem {
    return { type: 'mesa', label, x, y, rotation: 270, plano, width: 50, height: 50 };
  }

  crearMesasManuales(): PlanoItem[] {
    const mesas: PlanoItem[] = [];
    const posiciones = [
      { x: 77, yStart: 14 }, { x: 69, yStart: 14 }, { x: 61, yStart: 14 },
      { x: 53, yStart: 14 }, { x: 45, yStart: 14 }, { x: 33, yStart: 14 },
      { x: 25, yStart: 14 }, { x: 17, yStart: 14 }, { x: 9, yStart: 14 }
    ];

    let labelCounter = 1;
    for (const { x, yStart } of posiciones) {
      for (let i = 0; i < 5; i++) {
        mesas.push(this.crearMesa(`Mesa ${labelCounter++}`, x, yStart + 15 * i, 2));
      }
    }
    return mesas;
  }
}