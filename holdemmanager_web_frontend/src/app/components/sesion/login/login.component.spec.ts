import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService, ToastrModule } from 'ngx-toastr';
import { of, throwError } from 'rxjs';
import { LoginComponent } from './login.component';
import { LoginService } from 'src/app/service/login.service';
import { HttpClientTestingModule } from '@angular/common/http/testing';

describe('LoginComponent', () => {
  let component: LoginComponent;
  let fixture: ComponentFixture<LoginComponent>;
  let mockLoginService: any;
  let mockToastrService: any;
  let mockRouter: any;

  beforeEach(async () => {
    mockLoginService = jasmine.createSpyObj('LoginService', ['login', 'setLocalStorage']);
    mockToastrService = jasmine.createSpyObj('ToastrService', ['error']);
    mockRouter = jasmine.createSpyObj('Router', ['navigate']);

    await TestBed.configureTestingModule({
      declarations: [LoginComponent],
      imports: [
        ReactiveFormsModule,
        HttpClientTestingModule,
        ToastrModule.forRoot()
      ],
      providers: [
        { provide: LoginService, useValue: mockLoginService },
        { provide: ToastrService, useValue: mockToastrService },
        { provide: Router, useValue: mockRouter },
      ],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LoginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('debería crear el componente', () => {
    expect(component).toBeTruthy();
  });

  it('debería tener el formulario de login inválido cuando está vacío', () => {
    expect(component.login.valid).toBeFalsy();
  });

  it('debería validar el formulario cuando los campos son válidos', () => {
    component.login.controls['nombreUsuario'].setValue('usuario_test');
    component.login.controls['password'].setValue('password123');
    expect(component.login.valid).toBeTruthy();
  });

  it('debería llamar al método de login del servicio cuando se envía el formulario', () => {
    component.login.controls['nombreUsuario'].setValue('usuario_test');
    component.login.controls['password'].setValue('password123');
    const mockResponse = { token: 'test_token' };
    mockLoginService.login.and.returnValue(of(mockResponse));

    component.log();

    expect(mockLoginService.login).toHaveBeenCalled();
    expect(mockLoginService.setLocalStorage).toHaveBeenCalledWith('test_token');
    expect(mockRouter.navigate).toHaveBeenCalledWith(['/dashboard']);
  });

  it('debería mostrar un mensaje de error cuando el login falla', () => {
    component.login.controls['nombreUsuario'].setValue('usuario_test');
    component.login.controls['password'].setValue('password123');
    const mockError = { error: { message: 'Credenciales inválidas' } };
    mockLoginService.login.and.returnValue(throwError(mockError));

    component.log();

    expect(mockToastrService.error).toHaveBeenCalledWith('Credenciales inválidas', 'Error');
    expect(component.loading).toBeFalsy();
  });

  it('debería resetear el formulario cuando el login falla', () => {
    component.login.controls['nombreUsuario'].setValue('usuario_test');
    component.login.controls['password'].setValue('password123');
    const mockError = { error: { message: 'Credenciales inválidas' } };
    mockLoginService.login.and.returnValue(throwError(mockError));
  
    component.log();
  
    expect(component.login.controls['nombreUsuario'].value).toBeNull();
    expect(component.login.controls['password'].value).toBeNull();
  });

  it('debería establecer loading a true cuando se envía el formulario', () => {
    component.login.controls['nombreUsuario'].setValue('usuario_test');
    component.login.controls['password'].setValue('password123');
    const mockResponse = { token: 'test_token' };
    mockLoginService.login.and.returnValue(of(mockResponse));

    component.log();

    expect(component.loading).toBeTrue();
  });

  it('debería establecer loading a false cuando el login falla', () => {
    component.login.controls['nombreUsuario'].setValue('usuario_test');
    component.login.controls['password'].setValue('password123');
    const mockError = { error: { message: 'Credenciales inválidas' } };
    mockLoginService.login.and.returnValue(throwError(mockError));

    component.log();

    expect(component.loading).toBeFalse();
  });
});