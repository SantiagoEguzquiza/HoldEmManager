import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { ToastrModule } from 'ngx-toastr';
import { RouterTestingModule } from '@angular/router/testing';
import { of } from 'rxjs';
import Swal, { SweetAlertResult } from 'sweetalert2';

import { ContactosComponent } from './contactos.component';
import { ContactoService } from 'src/app/service/contacto.service';
import { LoadingComponent } from 'src/app/shared/loading/loading.component';

describe('ContactosComponent', () => {
  let component: ContactosComponent;
  let fixture: ComponentFixture<ContactosComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ContactosComponent, LoadingComponent],
      imports: [
        FormsModule,
        ReactiveFormsModule,
        HttpClientTestingModule,
        ToastrModule.forRoot(),
        RouterTestingModule
      ],
      providers: [
        ContactoService
      ]
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ContactosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('debería eliminar un contacto y mostrar un mensaje de éxito', async () => {
    spyOn(Swal, 'fire').and.returnValue(Promise.resolve<SweetAlertResult<any>>({
      isConfirmed: true,
      isDenied: false,
      isDismissed: false,
      value: null
    }));

    const eliminarContactoSpy = spyOn(component['contactosService'], 'eliminarContacto').and.returnValue(of({}));
    const obtenerContactosSpy = spyOn(component, 'obtenerContactos');
    const toastrSpy = spyOn(component['toastr'], 'success');

    await component.eliminarContacto(1);

    expect(eliminarContactoSpy).toHaveBeenCalledWith(1);
    expect(obtenerContactosSpy).toHaveBeenCalled();
    expect(toastrSpy).toHaveBeenCalledWith('Contacto eliminado correctamente', 'Éxito');
  });

  it('debería cambiar la página y obtener contactos', () => {
    const obtenerContactosSpy = spyOn(component, 'obtenerContactos').and.callThrough();
  
    component.page = 1; 
    component.hasNextPage = true;
  
    component.onPageChange(2);
  
    expect(component.page).toBe(2);
    expect(obtenerContactosSpy).toHaveBeenCalled();
  });
});