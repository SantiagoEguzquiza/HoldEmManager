import { Component, OnInit } from '@angular/core';
import { UsuarioWeb } from 'src/app/models/usuarioWeb';
import { UsuarioService } from 'src/app/service/usuario.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  loading = false;
  usuario: UsuarioWeb;

  constructor(private usuarioService: UsuarioService) {
    this.usuario = new UsuarioWeb();
  }

  ngOnInit() {
    this.getUsuario();
  }

  getUsuario(): void {
    this.loading = true;
    this.usuarioService.getUsuario().subscribe(data => {
      this.usuario = data;
      this.loading = false;
    });
  }
}
