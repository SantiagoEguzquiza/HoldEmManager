import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { ToastrModule, ToastrService } from 'ngx-toastr';
import { FormsModule } from '@angular/forms';
import { of, throwError } from 'rxjs';
import Swal from 'sweetalert2';

import { NoticiasComponent } from './noticias.component';
import { NoticiasService } from 'src/app/service/noticias.service';
import { LoadingComponent } from 'src/app/shared/loading/loading.component';

describe('NoticiasComponent', () => {
  let component: NoticiasComponent;
  let fixture: ComponentFixture<NoticiasComponent>;
  let mockNoticiasService: any;
  let mockToastrService: any;

  beforeEach(async(() => {
    mockNoticiasService = jasmine.createSpyObj('NoticiasService', ['obtenerNoticias', 'eliminarNoticia', 'agregarNoticia', 'actualizarNoticia']);
    mockToastrService = jasmine.createSpyObj('ToastrService', ['success', 'error']);

    TestBed.configureTestingModule({
      declarations: [
        NoticiasComponent,
        LoadingComponent
      ],
      imports: [
        HttpClientTestingModule,
        ToastrModule.forRoot(),
        FormsModule
      ],
      providers: [
        { provide: NoticiasService, useValue: mockNoticiasService },
        { provide: ToastrService, useValue: mockToastrService }
      ]
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NoticiasComponent);
    component = fixture.componentInstance;

    mockNoticiasService.obtenerNoticias.and.returnValue(of({ items: [], hasNextPage: false }));
    mockNoticiasService.eliminarNoticia.and.returnValue(of({}));
    mockNoticiasService.agregarNoticia.and.returnValue(of({ id: 1, titulo: 'Nueva Noticia' }));
    mockNoticiasService.actualizarNoticia.and.returnValue(of({ id: 1, titulo: 'Noticia Actualizada' }));

    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should fetch noticias on initialization', () => {
    component.ngOnInit();
    expect(mockNoticiasService.obtenerNoticias).toHaveBeenCalled();
    expect(component.noticias.length).toBe(0);
  });

  it('should delete a noticia and show success message', async () => {
    spyOn(Swal, 'fire').and.returnValue(Promise.resolve({ isConfirmed: true } as any));

    component.eliminarNoticia(1);

    await fixture.whenStable();
    expect(mockNoticiasService.eliminarNoticia).toHaveBeenCalledWith(1);
    expect(mockNoticiasService.obtenerNoticias).toHaveBeenCalled();
    expect(mockToastrService.success).toHaveBeenCalledWith('Noticia eliminada correctamente', 'Éxito');
  });

  it('should show error message when deleting fails', async () => {
    spyOn(Swal, 'fire').and.returnValue(Promise.resolve({ isConfirmed: true } as any));
    mockNoticiasService.eliminarNoticia.and.returnValue(throwError({ status: 500 }));

    component.eliminarNoticia(1);

    await fixture.whenStable();
    expect(mockNoticiasService.eliminarNoticia).toHaveBeenCalledWith(1);
    expect(mockToastrService.error).toHaveBeenCalledWith('Error al eliminar noticia', 'Error');
  });

  it('should apply filter and fetch noticias', () => {
    spyOn(component, 'obtenerNoticias');
    component.aplicarFiltro();

    expect(component.page).toBe(1);
    expect(component.obtenerNoticias).toHaveBeenCalled();
  });

  it('should apply date filter and fetch noticias', () => {
    spyOn(component, 'obtenerNoticias');
    component.aplicarFiltroFecha();

    expect(component.page).toBe(1);
    expect(component.obtenerNoticias).toHaveBeenCalled();
  });
});