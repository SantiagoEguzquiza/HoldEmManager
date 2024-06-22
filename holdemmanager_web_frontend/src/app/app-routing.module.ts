import { NgModule } from '@angular/core'
import { RouterModule, Routes } from '@angular/router';
import { RegisterPlayerComponent } from './components/dashboard/player-register/player-register.component';
import { LoginComponent } from './components/sesion/login/login.component';
import { SesionComponent } from './components/sesion/sesion.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { HomeComponent } from './components/dashboard/home/home.component';
import { AuthGuard } from './helpers/auth.guard';
import { AuthRedirectGuard } from './helpers/auth-redirect.guard';
import { RecursosRegisterComponent } from './components/dashboard/recursos-register/recursos-register.component';
import { MapaInteractivoComponent } from './components/dashboard/mapa-interactivo/mapa-interactivo.component';
import { RecursosEditDeleteComponent } from './components/dashboard/recursos-edit-delete/recursos-edit-delete.component';
import { RecursosEditComponent } from './components/recursos-edit/recursos-edit.component';

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
      { path: 'register-player', component: RegisterPlayerComponent },
      { path: 'recursos-register', component: RecursosRegisterComponent},
      { path: 'mapa', component: MapaInteractivoComponent},
      { path: 'recursos-edit-delete', component: RecursosEditDeleteComponent},
      { path: 'recursos-edit', component: RecursosEditComponent},
      { path: 'recursos-edit/:id', component: RecursosEditComponent }
    ]
  },
  { path: '**', redirectTo: '/dashboard/home'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
