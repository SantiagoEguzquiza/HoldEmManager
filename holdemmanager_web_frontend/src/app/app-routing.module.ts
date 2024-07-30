import { NgModule } from '@angular/core'
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/sesion/login/login.component';
import { SesionComponent } from './components/sesion/sesion.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { HomeComponent } from './components/dashboard/home/home.component';
import { MapaInteractivoComponent } from './components/dashboard/mapa-interactivo/mapa-interactivo.component';
// Players
import { CreatePlayerComponent } from './components/dashboard/players/create-player/create-player.component';
// Recursos
import { CreateRecursoComponent } from './components/dashboard/recursos/create-recurso/create-recursos.component';
import { RecursosComponent } from './components/dashboard/recursos/recursos.component';
import { EditRecursosComponent } from './components/dashboard/recursos/edit-recursos/edit-recursos.component';
// Contactos
import { CreateContactoComponent } from './components/dashboard/contactos/create-contacto/create-contacto.component';
import { ContactosComponent } from './components/dashboard/contactos/contactos.component';
import { EditContactoComponent } from './components/dashboard/contactos/edit-contacto/edit-contacto.component';
//Noticias
import { NoticiasComponent } from './components/dashboard/noticias/noticias.component';
// Guards
import { AuthGuard } from './helpers/auth.guard';
import { AuthRedirectGuard } from './helpers/auth-redirect.guard';
import { PlayersComponent } from './components/dashboard/players/players.component';
import { EditPlayerComponent } from './components/dashboard/players/edit-player/edit-player.component';
import { FeedbackComponent } from './components/dashboard/feedback/feedback.component';
import { TorneosComponent } from './components/dashboard/torneos/torneos.component';


const routes: Routes = [
  { path: '', redirectTo: '/sesion/login', pathMatch: 'full' },
  {
    path: 'sesion', component: SesionComponent, children: [
      { path: '', redirectTo: 'login', pathMatch: 'full' },
      { path: 'login', component: LoginComponent, canActivate: [AuthRedirectGuard] },
    ]
  },
  {
    path: 'dashboard', component: DashboardComponent, canActivate: [AuthGuard], children: [
      { path: '', redirectTo: 'home', pathMatch: 'full' },
      { path: 'home', component: HomeComponent },
      { path: 'players', component: PlayersComponent },
      { path: 'create-player', component: CreatePlayerComponent },
      { path: 'edit-player/:id', component: EditPlayerComponent },
      { path: 'recursos', component: RecursosComponent},
      { path: 'edit-recurso/:id', component: EditRecursosComponent },
      { path: 'create-recurso', component: CreateRecursoComponent},
      { path: 'contactos', component: ContactosComponent},
      { path: 'create-contacto', component: CreateContactoComponent},
      { path: 'edit-contacto/:id', component: EditContactoComponent},
      { path: 'mapa', component: MapaInteractivoComponent},
      { path: 'noticias', component: NoticiasComponent},
      { path: 'feedback', component: FeedbackComponent},
      { path: 'torneos', component: TorneosComponent}
    ]
  },
  { path: '**', redirectTo: '/dashboard/home'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
