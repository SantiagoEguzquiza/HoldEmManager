import { NgModule } from '@angular/core'
import { RouterModule, Routes } from '@angular/router';
import { RegisterComponent } from './components/inicio/register/register.component';
import { LoginComponent } from './components/inicio/login/login.component';
import { InicioComponent } from './components/inicio/inicio.component';
import { CambiarPasswordComponent } from './components/cambiar-password/cambiar-password.component';

const routes: Routes = [

  { path: '', redirectTo: '/inicio/login', pathMatch: 'full' },
  {
    path: 'inicio', component: InicioComponent, children: [
      { path: 'register', component: RegisterComponent },
      { path: 'login', component: LoginComponent },
    ]
  },
  { path: 'cambiar-password', component: CambiarPasswordComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
