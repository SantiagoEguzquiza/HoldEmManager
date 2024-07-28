import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { UsuarioWeb } from 'src/app/models/usuarioWeb';
import { LoginService } from 'src/app/service/login.service';
import { UsuarioService } from 'src/app/service/usuario.service';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent {
  loading = false;
  usuario: UsuarioWeb;

  constructor(private loginService: LoginService, private usuarioService: UsuarioService, private router: Router) 
  {
    this.usuario = new UsuarioWeb();
    this.getUsuario();
  }

  isComentariosActive():boolean{
    return this.router.url === '/dashboard/feedback';
  }

  isJugadoresActive(): boolean {
    return this.router.url === '/dashboard/players';
  }

  isHomeActive(): boolean {
    return this.router.url === '/dashboard/home';
  }

  logOut(): void {
    this.loginService.removeLocaStorage();
    this.router.navigate(['/sesion/login']);
  }

  getUsuario(): void {
    this.loading = true;
    this.usuarioService.getUsuario().subscribe(data => {
      if (data == null) {
        localStorage.removeItem('token');
        this.router.navigate(['/sesion/login']);
      }
      this.usuario = data;
      this.loading = false;
    });
  }
}
