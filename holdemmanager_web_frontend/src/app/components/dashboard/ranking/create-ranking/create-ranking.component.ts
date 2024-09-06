import { Component, EventEmitter, Output } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';

import { Ranking, RankingEnum } from 'src/app/models/ranking';

@Component({
  selector: 'app-create-ranking',
  templateUrl: './create-ranking.component.html',
  styleUrls: ['./create-ranking.component.css']
})
export class CreateRankingComponent {

  rankingForm: FormGroup;
  public RankingEnum = RankingEnum;
  public rankingEnumOptions: { key: string, value: number }[];

  @Output() guardar = new EventEmitter<Ranking>();
  @Output() cancelar = new EventEmitter<void>();

  constructor(private fb: FormBuilder) {
    this.rankingForm = this.fb.group({
      id: [0],
      playerNumber: ['', [Validators.required, Validators.pattern('^[0-9]*$'), this.noSoloGuionValidator]],
      playerName: ['', Validators.required],
      puntuacion: ['', [Validators.required, Validators.pattern('^[0-9]*$')]],
      rankingEnum: ['', Validators.required]
    });

    
    this.rankingEnumOptions = Object.keys(RankingEnum)
      .filter(key => isNaN(Number(key)))
      .map(key => ({ key, value: RankingEnum[key as keyof typeof RankingEnum] }));
  }


  noSoloGuionValidator(control: AbstractControl): { [key: string]: any } | null {
    const value = control.value;
    return value === '-' ? { 'noSoloGuion': true } : null;
  }

  onSubmit() {
    if (this.rankingForm.valid) {
      const formValue = {
        ...this.rankingForm.value,
        playerNumber: Number(this.rankingForm.value.playerNumber), 
        puntuacion: Number(this.rankingForm.value.puntuacion),     
        rankingEnum: Number(this.rankingForm.value.rankingEnum)    
      };
      this.guardar.emit(formValue);
    }
  }


  onCancel(): void {
    this.cancelar.emit();
  }
}
