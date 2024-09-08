
import { Component, EventEmitter, Input, OnInit, Output, OnChanges, SimpleChanges } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Ranking, RankingEnum } from 'src/app/models/ranking';


@Component({
  selector: 'app-edit-ranking',
  templateUrl: './edit-ranking.component.html',
  styleUrls: ['./edit-ranking.component.css']
})
export class EditRankingComponent implements OnInit, OnChanges {
  loading = false;

  rankingForm: FormGroup;
  public rankingEnumOptions: { key: string, value: number }[];

  @Input() ranking!: Ranking;

  @Output() guardar = new EventEmitter<Ranking>();
  @Output() cancelar = new EventEmitter<void>();

  constructor(
    private fb: FormBuilder) {
    this.rankingForm = this.fb.group({
      id: [0],
      playerNumber: ['', [Validators.required, Validators.pattern('^[0-9-]*$')]],
      playerName: ['', Validators.required],
      puntuacion: ['', [Validators.required, Validators.pattern('^[0-9-]*$')]],
      rankingEnum:['', [Validators.required]]
    });

    this.rankingEnumOptions = Object.keys(RankingEnum)
      .filter(key => isNaN(Number(key)))
      .map(key => ({ key, value: RankingEnum[key as keyof typeof RankingEnum] }));
  }

  ngOnInit(): void {
    if (this.ranking) {
      this.rankingForm.patchValue(this.ranking);
    }
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['ranking'] && changes['ranking'].currentValue) {
      this.rankingForm.patchValue(this.ranking);
    }
  }
  

  guardarRanking() {
    if (this.rankingForm.valid) {
      this.loading = true;
      const formValue = {
        ...this.rankingForm.value,         
        rankingEnum: Number(this.rankingForm.value.rankingEnum)    
      };
      this.guardar.emit(formValue);
    }
  }

  cancelarEdicion() {
    this.cancelar.emit();
  }

  get playerNumber() {
    return this.rankingForm.get('playerNumber');
  }

  get playerName() {
    return this.rankingForm.get('playerName');
  }

  get puntuacion() {
    return this.rankingForm.get('puntuacion');
  }

  get rankingEnum() {
    return this.rankingForm.get('rankingEnum');
  }

  
}
