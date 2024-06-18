import { NgModule } from '@angular/core'
import { RouterModule, Routes } from '@angular/router';
import { RegisterPlayerComponent } from './components/dashboard/player-register/player-register.component';
import { LoginComponent } from './components/sesion/login/login.component';
import { SesionComponent } from './components/sesion/sesion.component';
import { CambiarPasswordComponent } from './components/dashboard/cambiar-password/cambiar-password.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { HomeComponent } from './components/dashboard/home/home.component';

const routes: Routes = [

  { path: '', redirectTo: '/sesion/login', pathMatch: 'full' },
  {
    path: 'sesion', component: SesionComponent, children: [
      { path: 'login', component: LoginComponent },
    ]
  },
  {
    path: 'dashboard', component: DashboardComponent, children: [
      { path: '', redirectTo: 'home', pathMatch: 'full' },
      { path: 'home', component: HomeComponent },
      { path: 'register-player', component: RegisterPlayerComponent },
      { path: 'cambiar-password', component: CambiarPasswordComponent }
    ]
  },
  
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
