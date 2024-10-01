import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { ToastrModule } from 'ngx-toastr';
import { RouterTestingModule } from '@angular/router/testing';

import { EditRankingComponent } from './edit-ranking.component';
import { RankingService } from 'src/app/service/ranking.service';

describe('EditRankingComponent', () => {
  let component: EditRankingComponent;
  let fixture: ComponentFixture<EditRankingComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [EditRankingComponent],
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
    fixture = TestBed.createComponent(EditRankingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});