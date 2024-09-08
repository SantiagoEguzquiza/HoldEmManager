import { Component, EventEmitter, Input, OnInit, Output, OnChanges, SimpleChanges } from '@angular/core';
import { FormBuilder, FormGroup, Validators, AbstractControl } from '@angular/forms';
import { Jugador } from 'src/app/models/jugador';

@Component({
  selector: 'app-edit-player',
  templateUrl: './edit-player.component.html',
  styleUrls: ['./edit-player.component.css']
})
export class EditPlayerComponent implements OnInit, OnChanges {
  loading = false;
  jugadorForm: FormGroup;

  @Input() jugador!: Jugador;

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

  ngOnInit(): void {
    if (this.jugador) {
      this.jugadorForm.patchValue(this.jugador);
    }
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['jugador'] && changes['jugador'].currentValue) {
      this.jugadorForm.patchValue(this.jugador);
    }
  }

  guardarJugador() {
    if (this.jugadorForm.valid) {
      this.loading = true;
      this.guardar.emit(this.jugadorForm.value);
    }
  }

  cancelarEdicion() {
    this.cancelar.emit();
  }

  noSoloGuionValidator(control: AbstractControl): { [key: string]: any } | null {
    const value = control.value;
    return value === '-' ? { 'noSoloGuion': true } : null;
  }

  emailComValidator(control: AbstractControl): { [key: string]: any } | null {
    const value = control.value;
    return value.endsWith('.com') ? null : { 'email': true };
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