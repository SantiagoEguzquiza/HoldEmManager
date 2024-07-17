import { Component, EventEmitter, Output } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';

interface Jugador {
  id: number;
  numberPlayer: number;
  name: string;
  email: string;
  password: string;
  imageUrl?: string;
}

@Component({
  selector: 'app-create-player',
  templateUrl: './create-player.component.html',
  styleUrls: ['./create-player.component.css']
})
export class CreatePlayerComponent {
  jugadorForm: FormGroup;

  @Output() guardar = new EventEmitter<Jugador>();
  @Output() cancelar = new EventEmitter<void>();

  constructor(private fb: FormBuilder) {
    this.jugadorForm = this.fb.group({
      id: [0],
      numberPlayer: ['', [Validators.required, Validators.pattern('^[0-9-]*$')]],
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email, this.gmailValidator]],
      password: ['', Validators.required], 
      imageUrl: ['']
    });
  }

  gmailValidator(control: AbstractControl): {[key: string]: any} | null {
    const email = control.value;
    return email.endsWith('@gmail.com') ? null : { 'gmail': true };
  }

  guardarJugador() {
    if (this.jugadorForm.valid) {
      this.guardar.emit(this.jugadorForm.value);
    }
  }

  cancelarCreacion() {
    this.cancelar.emit();
  }

  get numberPlayer() {
    return this.jugadorForm.get('numberPlayer');
  }

  get name() {
    return this.jugadorForm.get('name');
  }

  get email() {
    return this.jugadorForm.get('email');
  }

  get password() {
    return this.jugadorForm.get('password');
  }

  get confirmPassword() {
    return this.jugadorForm.get('confirmPassword');
  }

  get imageUrl() {
    return this.jugadorForm.get('imageUrl');
  }
}
