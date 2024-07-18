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
    { type: 'banio', label: 'Bathrooms', x: 70, y: 15, rotation: 0, plano: 1, width: 65, height: 40 },
    { type: 'caja', label: 'Cashier', x: 38.5, y: 88, rotation: -90, plano: 1, width: 60, height: 35 },
    { type: 'marketing', label: 'Marketing', x: 37.4, y: 70, rotation: -90, plano: 1, width: 80, height: 35 },
    { type: 'infotorneos', label: 'Tournament Information', x: 90, y: 88.3, rotation: 0, plano: 2, width: 80, height: 50 },
    { type: 'prensa', label: 'Press', x: 92.8, y: 20, rotation: 90, plano: 2, width: 70, height: 40 },
    { type: 'agua', label: '', x: 31, y: 2, rotation: 0, plano: 2, width: 20, height: 20 },
    { type: 'agua', label: '', x: 61, y: 2, rotation: 0, plano: 2, width: 20, height: 20 },
    { type: 'agua', label: '', x: 31, y: 93.5, rotation: 0, plano: 2, width: 20, height: 20 },
    { type: 'agua', label: '', x: 61, y: 93.5, rotation: 0, plano: 2, width: 20, height: 20 },
    { type: 'salatorneo', label: 'Tournament Room', x: 68, y: 65, rotation: 90, plano: 1, width: 200, height: 100 },
    { type: 'barbero', label: 'Barber', x: 55.7, y: 65, rotation: 90, plano: 1, width: 50, height: 30 },
    { type: 'entretenimiento', label: 'Entertainment', x: 54.5, y: 73.5, rotation: 90, plano: 1, width: 60, height: 45 },
    ...this.crearMesasManuales()
  ];

  items: PlanoItem[] = JSON.parse(JSON.stringify(this.itemsOriginales));

  private currentItemDragging: PlanoItem | null = null;
  private mouseMovimientoListener: (() => void) | null = null;
  private mouseArribaListener: (() => void) | null = null;
  private leftMouseDown = false;

  constructor(private renderer: Renderer2, private el: ElementRef, private mapaService: MapaService, private toastr : ToastrService) { }

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

  exportarImagen(): void {
    const container = this.el.nativeElement.querySelector('#plano-container');
    html2canvas(container, {
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
        this.toastr.error(error.message, 'Error');
        console.error(error);
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
      { type: 'mesa', label: 'Mesa 1', x: 77, y: 14, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 2', x: 77, y: 29, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 3', x: 77, y: 44, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 4', x: 77, y: 59, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 5', x: 77, y: 74, rotation: 270, plano: 2, width: 50, height: 50 },
  
      { type: 'mesa', label: 'Mesa 6', x: 69, y: 14, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 7', x: 69, y: 29, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 8', x: 69, y: 44, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 9', x: 69, y: 59, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 10', x: 69, y: 74, rotation: 270, plano: 2, width: 50, height: 50 },
  
      { type: 'mesa', label: 'Mesa 11', x: 61, y: 14, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 12', x: 61, y: 29, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 13', x: 61, y: 44, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 14', x: 61, y: 59, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 15', x: 61, y: 74, rotation: 270, plano: 2, width: 50, height: 50 },
  
      { type: 'mesa', label: 'Mesa 16', x: 53, y: 14, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 17', x: 53, y: 29, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 18', x: 53, y: 44, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 19', x: 53, y: 59, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 20', x: 53, y: 74, rotation: 270, plano: 2, width: 50, height: 50 },
  
      { type: 'mesa', label: 'Mesa 21', x: 45, y: 14, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 22', x: 45, y: 29, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 23', x: 45, y: 44, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 24', x: 45, y: 59, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 25', x: 45, y: 74, rotation: 270, plano: 2, width: 50, height: 50 },
  
      { type: 'mesa', label: 'Mesa 26', x: 33, y: 14, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 27', x: 33, y: 29, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 28', x: 33, y: 44, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 29', x: 33, y: 59, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 30', x: 33, y: 74, rotation: 270, plano: 2, width: 50, height: 50 },
  
      { type: 'mesa', label: 'Mesa 31', x: 25, y: 14, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 32', x: 25, y: 29, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 33', x: 25, y: 44, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 34', x: 25, y: 59, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 35', x: 25, y: 74, rotation: 270, plano: 2, width: 50, height: 50 },
  
      { type: 'mesa', label: 'Mesa 36', x: 17, y: 14, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 37', x: 17, y: 29, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 38', x: 17, y: 44, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 39', x: 17, y: 59, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 40', x: 17, y: 74, rotation: 270, plano: 2, width: 50, height: 50 },
  
      { type: 'mesa', label: 'Mesa 41', x: 9, y: 14, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 42', x: 9, y: 29, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 43', x: 9, y: 44, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 44', x: 9, y: 59, rotation: 270, plano: 2, width: 50, height: 50 },
      { type: 'mesa', label: 'Mesa 45', x: 9, y: 74, rotation: 270, plano: 2, width: 50, height: 50 }
    ];
  }
}
