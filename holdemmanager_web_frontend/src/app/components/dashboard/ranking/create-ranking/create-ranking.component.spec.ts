import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { ToastrModule } from 'ngx-toastr';
import { RouterTestingModule } from '@angular/router/testing';

import { CreateRankingComponent } from './create-ranking.component';
import { RankingService } from 'src/app/service/ranking.service';

describe('CreateRankingComponent', () => {
  let component: CreateRankingComponent;
  let fixture: ComponentFixture<CreateRankingComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [CreateRankingComponent],
      imports: [
        FormsModule,
        ReactiveFormsModule,
        HttpClientTestingModule,
        ToastrModule.forRoot(),
        RouterTestingModule
      ],
      providers: [
        RankingService
      ]
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CreateRankingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});