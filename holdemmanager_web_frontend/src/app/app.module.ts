import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

//Modules
import { AppRoutingModule } from './app-routing.module';
import { ReactiveFormsModule } from '@angular/forms';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ToastrModule } from 'ngx-toastr';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http'

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

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RegisterPlayerComponent,
    NavbarComponent,
    LoadingComponent,
    DashboardComponent,
    SesionComponent,
    HomeComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    ReactiveFormsModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot(),
    HttpClientModule
  ],
  providers: [{ provide: HTTP_INTERCEPTORS, useClass: AddTokenInterceptor, multi: true },
    AuthGuard,
    AuthRedirectGuard,
    LoginService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
