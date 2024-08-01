import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

//Modules
import { AppRoutingModule } from './app-routing.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ToastrModule } from 'ngx-toastr';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http'
import { CommonModule } from '@angular/common';

// nterceptors
import { AddTokenInterceptor } from '../app/helpers/add-token.interceptor';

// Guards
import { AuthGuard } from './helpers/auth.guard';
import { AuthRedirectGuard } from './helpers/auth-redirect.guard';

// Componentes
import { AppComponent } from './app.component';
import { LoginComponent } from './components/sesion/login/login.component';
import { NavbarComponent } from './components/dashboard/navbar/navbar.component';
import { LoadingComponent } from './shared/loading/loading.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { SesionComponent } from './components/sesion/sesion.component';
import { HomeComponent } from './components/dashboard/home/home.component';
import { LoginService } from './service/login.service';
// Mapa
import { HelpComponent } from './components/dashboard/mapa-interactivo/help/help.component';
import { MapaInteractivoComponent } from './components/dashboard/mapa-interactivo/mapa-interactivo.component';
// Recursos
import { RecursosComponent } from './components/dashboard/recursos/recursos.component';
import { CreateEditRecursoComponent } from './components/dashboard/recursos/create-edit-recurso/create-edit-recurso.component';
// Players
import {CreatePlayerComponent } from './components/dashboard/players/create-player/create-player.component';
import { EditPlayerComponent } from './components/dashboard/players/edit-player/edit-player.component';
import { PlayersComponent } from './components/dashboard/players/players.component';
// Contactos
import { CreateEditContactoComponent } from './components/dashboard/contactos/create-edit-contacto/create-edit-contacto.component';
import { ContactosComponent } from './components/dashboard/contactos/contactos.component';


import { SweetAlert2Module } from '@sweetalert2/ngx-sweetalert2';
import { CreateItemComponent } from './components/dashboard/mapa-interactivo/create-item/create-item.component';
import { position } from 'html2canvas/dist/types/css/property-descriptors/position';
import { TorneosComponent } from './components/dashboard/torneos/torneos.component';
import { CreateTorneoComponent } from './components/dashboard/torneos/create-torneo/create-torneo.component';
import { NoticiasComponent } from './components/dashboard/noticias/noticias.component';
import { CreateEditNoticiaComponent } from './components/dashboard/noticias/create-edit-noticia/create-edit-noticia.component';
import { FeedbackComponent } from './components/dashboard/feedback/feedback.component';
import { RankingComponent } from './components/dashboard/ranking/ranking.component';
import { AgGridModule } from 'ag-grid-angular';
import { FeedbackDetailsComponent } from './components/dashboard/feedback/feedback-details/feedback-details.component';



@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    // Players
    CreatePlayerComponent,
    NavbarComponent,
    LoadingComponent,
    DashboardComponent,
    SesionComponent,
    HomeComponent,
    EditPlayerComponent,
    PlayersComponent,
    // Recursos
    RecursosComponent,
    CreateEditRecursoComponent,
    // Mapa
    HelpComponent,
    MapaInteractivoComponent,
    CreateItemComponent,
    // Contactos
    CreateEditContactoComponent,
    ContactosComponent,
    //Noticias
    NoticiasComponent,
    CreateEditNoticiaComponent,
    //Feedback
     FeedbackComponent,
     FeedbackDetailsComponent,
    //Ranking
    RankingComponent,
    //Torneos
    TorneosComponent,
    CreateTorneoComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    CommonModule,
    ReactiveFormsModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot({positionClass : 'toast-bottom-right'}),
    HttpClientModule,
    FormsModule,
    SweetAlert2Module.forRoot(),
    AgGridModule
  ],
  providers: [{ provide: HTTP_INTERCEPTORS, useClass: AddTokenInterceptor, multi: true },
    AuthGuard,
    AuthRedirectGuard,
    LoginService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
