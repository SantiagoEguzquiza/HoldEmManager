import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Jugador } from '../../../../models/jugador';
import { UsuarioService } from 'src/app/service/usuario.service';

@Component({
  selector: 'app-create-player',
  templateUrl: './create-player.component.html',
  styleUrls: ['./create-player.component.css']
})
export class CreatePlayerComponent {
  register: FormGroup;
  loading = false;

  constructor(
    private fb: FormBuilder,
    private usuarioService: UsuarioService,
    private router: Router,
    private toastr: ToastrService
  ) {
    this.register = this.fb.group({
      name: ['', Validators.required],
      numberPlayer: ['', [Validators.required, Validators.pattern('^[0-9-]*$')]],
      email: ['', [Validators.required, Validators.email, this.gmailValidator]],
      password: ['', Validators.required],
      confirmPassword: ['']
    }, { validator: this.checkPassword });
  }

  registrarUsuario(): void {
    if (this.register.invalid) {
      this.toastr.error('Por favor, complete todos los campos correctamente.', 'Error!');
      return;
    }

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
      this.router.navigate(['/dashboard/players']);
      this.loading = false;
    }, error => {
      this.loading = false;
      this.register.reset();
      this.toastr.error(error.error.message, 'Error!');
    });
  }

  checkPassword(group: FormGroup): ValidationErrors | null {
    const pass = group.get('password')?.value;
    const confirmPass = group.get('confirmPassword')?.value;
    return pass === confirmPass ? null : { notSame: true };
  }

  gmailValidator(control: AbstractControl): ValidationErrors | null {
    const email = control.value;
    if (!email) return null;
    const domain = email.substring(email.lastIndexOf('@') + 1);
    return domain === 'gmail.com' ? null : { gmail: true };
  }
}