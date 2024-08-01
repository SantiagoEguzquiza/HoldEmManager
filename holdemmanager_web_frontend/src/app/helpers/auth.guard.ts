import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { LoginService } from '../service/login.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private router: Router, private loginService: LoginService) {}

  canActivate(): boolean {
    if (this.loginService.getToken() == null) {
      this.router.navigate(['/sesion/login']);
      return false;
    }
    return true;
  }
}
