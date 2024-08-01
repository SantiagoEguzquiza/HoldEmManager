import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { RolesEnum } from 'src/app/models/roles';
import { UsuarioWeb } from 'src/app/models/usuarioWeb';
import { UsuarioService } from 'src/app/service/usuario.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {

  loading = false;
  usuario: UsuarioWeb;
  roles = RolesEnum;

  constructor(private usuarioService: UsuarioService, private toastr: ToastrService, private router: Router) {
    this.usuario = new UsuarioWeb();
    this.getUsuario();
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
