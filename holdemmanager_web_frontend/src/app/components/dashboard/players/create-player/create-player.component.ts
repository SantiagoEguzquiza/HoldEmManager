import { Component, EventEmitter, Output } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Jugador } from 'src/app/models/jugador';

@Component({
  selector: 'app-create-player',
  templateUrl: './create-player.component.html',
  styleUrls: ['./create-player.component.css']
})
export class CreatePlayerComponent {
  jugadorForm: FormGroup;
  loading = false;

  @Output() guardar = new EventEmitter<Jugador>();
  @Output() cancelar = new EventEmitter<void>();

  constructor(private fb: FormBuilder) {
    this.jugadorForm = this.fb.group({
      id: [0],
      numberPlayer: ['', [Validators.required, Validators.pattern('^[0-9-]*$'), this.noSoloGuionValidator]],
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email, this.emailComValidator]],
      password: ['', Validators.required],
      imageUrl: ['']
    });
  }

  noSoloGuionValidator(control: AbstractControl): { [key: string]: any } | null {
    const value = control.value;
    return value === '-' ? { 'noSoloGuion': true } : null;
  }

  emailComValidator(control: AbstractControl): { [key: string]: any } | null {
    const value = control.value;
    return value.endsWith('.com') ? null : { 'email': true };
  }

  guardarJugador() {
    if (this.jugadorForm.valid) {
      this.loading = true;
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

  get imageUrl() {
    return this.jugadorForm.get('imageUrl');
  }
}