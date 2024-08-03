import { NgModule } from '@angular/core'
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/sesion/login/login.component';
import { SesionComponent } from './components/sesion/sesion.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { HomeComponent } from './components/dashboard/home/home.component';
// Mapa
import { MapaInteractivoComponent } from './components/dashboard/mapa-interactivo/mapa-interactivo.component';
// Players
import { PlayersComponent } from './components/dashboard/players/players.component';
// Recursos
import { RecursosComponent } from './components/dashboard/recursos/recursos.component';
// Contactos
import { ContactosComponent } from './components/dashboard/contactos/contactos.component';
// Noticias
import { NoticiasComponent } from './components/dashboard/noticias/noticias.component';
// Feedback
import { FeedbackComponent } from './components/dashboard/feedback/feedback.component';
// Torneos
import { TorneosComponent } from './components/dashboard/torneos/torneos.component';
// Guards
import { AuthGuard } from './helpers/auth.guard';
import { AuthRedirectGuard } from './helpers/auth-redirect.guard';
import { RankingComponent } from './components/dashboard/ranking/ranking.component';



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
      { path: 'recursos', component: RecursosComponent},
      { path: 'contactos', component: ContactosComponent},
      { path: 'mapa', component: MapaInteractivoComponent},
      { path: 'noticias', component: NoticiasComponent},
      { path: 'feedback', component: FeedbackComponent},
      { path: 'torneos', component: TorneosComponent},     
      { path: 'ranking', component:RankingComponent},      
    ]
  },
  { path: '**', redirectTo: '/dashboard/home'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
