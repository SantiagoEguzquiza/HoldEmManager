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
import { NavbarComponent } from './components/dashboard/navbar/navbar.component';
import { LoadingComponent } from './shared/loading/loading.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { SesionComponent } from './components/sesion/sesion.component';
import { HomeComponent } from './components/dashboard/home/home.component';
import { AuthGuard } from './helpers/auth.guard';
import { LoginService } from './service/login.service';
import { AuthRedirectGuard } from './helpers/auth-redirect.guard';
import { MapaInteractivoComponent } from './components/dashboard/mapa-interactivo/mapa-interactivo.component';
import { RecursosComponent } from './components/dashboard/recursos/recursos.component';
import { SweetAlert2Module } from '@sweetalert2/ngx-sweetalert2';
import { CreateItemComponent } from './components/dashboard/mapa-interactivo/create-item/create-item.component';
import {CreatePlayerComponent } from './components/dashboard/players/create-player/create-player.component';
import { CreateRecursoComponent } from './components/dashboard/recursos/create-recurso/create-recursos.component';
import { EditRecursosComponent } from './components/dashboard/recursos/edit-recursos/edit-recursos.component';
import { CreateContactoComponent } from './components/dashboard/contactos/create-contacto/create-contacto.component';
import { ContactosComponent } from './components/dashboard/contactos/contactos.component';
import { EditContactoComponent } from './components/dashboard/contactos/edit-contacto/edit-contacto.component';


@NgModule({
  declarations: [	
    AppComponent,
    LoginComponent,
    CreatePlayerComponent,
    NavbarComponent,
    LoadingComponent,
    DashboardComponent,
    SesionComponent,
    HomeComponent,
    CreateRecursoComponent,
    MapaInteractivoComponent,
    RecursosComponent,
    EditRecursosComponent,
    CreateContactoComponent,
    ContactosComponent,
    EditContactoComponent,
    CreateItemComponent
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
    ToastrModule.forRoot({
      positionClass: 'toast-bottom-right', 
    }),
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
