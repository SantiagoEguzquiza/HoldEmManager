import { Component, EventEmitter, Input, OnInit, Output, OnChanges, SimpleChanges } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Jugador } from 'src/app/models/jugador';

@Component({
  selector: 'app-edit-player',
  templateUrl: './edit-player.component.html',
  styleUrls: ['./edit-player.component.css']
})
export class EditPlayerComponent implements OnInit, OnChanges {

  jugadorForm: FormGroup;

  @Input() jugador!: Jugador;

  @Output() guardar = new EventEmitter<Jugador>();
  @Output() cancelar = new EventEmitter<void>();

  constructor(
    private fb: FormBuilder) {
    this.jugadorForm = this.fb.group({
      id: [0],
      numberPlayer: ['', [Validators.required, Validators.pattern('^[0-9-]*$')]],
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
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
      this.guardar.emit(this.jugadorForm.value);
    }
  }

  cancelarEdicion() {
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
