import { NgModule } from '@angular/core'
import { RouterModule, Routes } from '@angular/router';
import { RegisterPlayerComponent } from './components/dashboard/player-register/player-register.component';
import { LoginComponent } from './components/sesion/login/login.component';
import { SesionComponent } from './components/sesion/sesion.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { HomeComponent } from './components/dashboard/home/home.component';
import { AuthGuard } from './helpers/auth.guard';
import { AuthRedirectGuard } from './helpers/auth-redirect.guard';
import { AlgoComponent } from './algo/algo.component';

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
    ]
  },
  { path: '**', redirectTo: '/dashboard/home'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
