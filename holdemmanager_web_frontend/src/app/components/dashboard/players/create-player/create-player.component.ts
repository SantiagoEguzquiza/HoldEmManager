import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Jugador } from '../../../../models/jugador';
import { UsuarioService } from 'src/app/service/usuario.service';

@Component({
  selector: 'app-player-register',
  templateUrl: './create-player.component.html',
  styleUrls: ['./create-player.component.css']
})
export class CreatePlayerComponent {
  register: FormGroup;
  loading = false;

  constructor(private fb: FormBuilder, private usuarioService: UsuarioService, private router: Router, private toastr: ToastrService) {

    this.register = this.fb.group({
      name: ['', Validators.required],
      numberPlayer: ['', Validators.required],
      email: ['', Validators.required],
      password: ['', [Validators.required, Validators.minLength(4)]],
      confirmPassword: ['']
    }, { validator: this.checkPassword });
  }



  registrarUsuario(): void {

    const usuario: Jugador = {

      id: 0,
      name: this.register.value.name,
      numberPlayer: this.register.value.numberPlayer,
      email: this.register.value.email,
      password: this.register.value.password,
      imageUrl: "."
    };

    this.loading = true;
    this.usuarioService.saveUser(usuario).subscribe(() => {
      this.toastr.success('El jugador ' + usuario.numberPlayer + ' fue registrado con exito!', 'Usuario Registrado!');
      this.router.navigate(['/inicio/login']);
      this.loading = false;


    }, error => {

      this.loading = false;
      this.register.reset;
      this.toastr.error(error.error.message, 'Error!');

    });


  }

  checkPassword(group: FormGroup): any {
    const pass = group.controls['password'].value;
    const confirmPass = group.controls['confirmPassword'].value;
    return pass === confirmPass ? null : { notSame: true }
  }
}
