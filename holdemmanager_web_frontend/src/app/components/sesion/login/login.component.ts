import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { Route, Router } from '@angular/router';
import { LoginService } from 'src/app/service/login.service';
import { UsuarioWeb } from 'src/app/models/usuarioWeb';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  loading = false;
  login: FormGroup;

  constructor(private fb: FormBuilder, private toastr: ToastrService, private router: Router, private loginService: LoginService) {

    this.login = this.fb.group({
      nombreUsuario: ['', Validators.required],
      password: ['', Validators.required]
    });
  }

  ngOnInit(): void {

  }

  log(): void {
    const usuario: UsuarioWeb = {
      nombreUsuario: this.login.value.nombreUsuario,
      password: this.login.value.password,
    }
    this.loading = true;
    this.loginService.login(usuario).subscribe(data => {

      this.loading = false;
      this.loginService.setLocalStorage(data.token)
      this.router.navigate(['/dashboard']);

    }, error => {
      this.loading = false;
      this.toastr.error(error.error.message ?? 'El servidor no se encuentra disponible', 'Error');
      this.login.reset();
    });
  }
}
