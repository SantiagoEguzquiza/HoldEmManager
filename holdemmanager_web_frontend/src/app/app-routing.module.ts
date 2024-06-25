import { NgModule } from '@angular/core'
import { RouterModule, Routes } from '@angular/router';
import { CreatePlayerComponent } from './components/dashboard/players/create-player/create-player.component';
import { LoginComponent } from './components/sesion/login/login.component';
import { SesionComponent } from './components/sesion/sesion.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { HomeComponent } from './components/dashboard/home/home.component';
import { AuthGuard } from './helpers/auth.guard';
import { AuthRedirectGuard } from './helpers/auth-redirect.guard';
import { CreateRecursoComponent } from './components/dashboard/recursos/create-recurso/create-recursos.component';
import { MapaInteractivoComponent } from './components/dashboard/mapa-interactivo/mapa-interactivo.component';
import { RecursosComponent } from './components/dashboard/recursos/recursos.component';
import { EditRecursosComponent } from './components/dashboard/recursos/edit-recursos/edit-recursos.component';
import { CreateContactoComponent } from './components/dashboard/contactos/create-contacto/create-contacto.component';
import { ContactosComponent } from './components/dashboard/contactos/contactos.component';
import { EditContactoComponent } from './components/dashboard/contactos/edit-contacto/edit-contacto.component';

// Guards
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
      { path: 'create-player', component: CreatePlayerComponent },
      { path: 'create-recurso', component: CreateRecursoComponent},
      { path: 'mapa', component: MapaInteractivoComponent},
      { path: 'recursos', component: RecursosComponent},
      { path: 'edit-recurso/:id', component: EditRecursosComponent },
      { path: 'create-contacto', component: CreateContactoComponent},
      { path: 'contactos', component: ContactosComponent},
      { path: 'edit-contacto/:id', component: EditContactoComponent}
    ]
  },
  { path: '**', redirectTo: '/dashboard/home'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
