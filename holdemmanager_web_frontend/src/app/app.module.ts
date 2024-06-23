import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

//Modules
import { AppRoutingModule } from './app-routing.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ToastrModule } from 'ngx-toastr';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http'
import { CommonModule } from '@angular/common';

//Interceptors
import { AddTokenInterceptor } from '../app/helpers/add-token.interceptor';

//Componentes
import { AppComponent } from './app.component';
import { LoginComponent } from './components/sesion/login/login.component';
import { RegisterPlayerComponent } from './components/dashboard/player-register/player-register.component';
import { NavbarComponent } from './components/dashboard/navbar/navbar.component';
import { LoadingComponent } from './shared/loading/loading.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { SesionComponent } from './components/sesion/sesion.component';
import { HomeComponent } from './components/dashboard/home/home.component';
import { AuthGuard } from './helpers/auth.guard';
import { LoginService } from './service/login.service';
import { AuthRedirectGuard } from './helpers/auth-redirect.guard';
import { RecursosRegisterComponent } from './components/dashboard/recursos-register/recursos-register.component';
import { MapaInteractivoComponent } from './components/dashboard/mapa-interactivo/mapa-interactivo.component';
import { RecursosEditDeleteComponent } from './components/dashboard/recursos-edit-delete/recursos-edit-delete.component';
import { RecursosEditComponent } from './components/dashboard/recursos-edit/recursos-edit.component';
import { ContactoRegisterComponent } from './components/dashboard/contacto-register/contacto-register.component';
import { ContactosEditDeleteComponent } from './components/dashboard/contactos-edit-delete/contactos-edit-delete.component';
import { ContactosEditComponent } from './components/dashboard/contactos-edit/contactos-edit.component';
import { SweetAlert2Module } from '@sweetalert2/ngx-sweetalert2';


@NgModule({
  declarations: [	
    AppComponent,
    LoginComponent,
    RegisterPlayerComponent,
    NavbarComponent,
    LoadingComponent,
    DashboardComponent,
    SesionComponent,
    HomeComponent,
    RecursosRegisterComponent,
    MapaInteractivoComponent,
    RecursosEditDeleteComponent,
    RecursosEditComponent,
    ContactoRegisterComponent,
    ContactosEditDeleteComponent,
    ContactosEditComponent
   ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    CommonModule,
    ReactiveFormsModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot(),
    HttpClientModule,
    FormsModule,
    ToastrModule.forRoot(),
    SweetAlert2Module.forRoot(),
  ],
  providers: [{ provide: HTTP_INTERCEPTORS, useClass: AddTokenInterceptor, multi: true },
    AuthGuard,
    AuthRedirectGuard,
    LoginService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
