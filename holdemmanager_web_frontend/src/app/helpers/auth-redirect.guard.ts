import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { LoginService } from '../service/login.service';

@Injectable()
export class AuthRedirectGuard implements CanActivate {
  constructor(private router: Router, private loginService: LoginService) {}

  canActivate(): boolean {
    console.log(this.loginService.getToken());
    if (this.loginService.getToken() != null) {
      this.router.navigate(['/dashboard/home']);
      return false;
    }
    return true;
  }
}
