import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { LoginService } from 'src/app/service/login.service';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent {

  constructor(private loginService: LoginService, private router: Router) {
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
}
