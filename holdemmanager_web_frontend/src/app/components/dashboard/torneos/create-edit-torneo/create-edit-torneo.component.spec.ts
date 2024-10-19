import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { ToastrModule } from 'ngx-toastr';
import { RouterTestingModule } from '@angular/router/testing';

import { CreateEditTorneoComponent } from './create-edit-torneo.component';
import { TorneosService } from 'src/app/service/torneos.service';

describe('CreateEditTorneoComponent', () => {
  let component: CreateEditTorneoComponent;
  let fixture: ComponentFixture<CreateEditTorneoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [CreateEditTorneoComponent],
      imports: [
        FormsModule,
        ReactiveFormsModule,
        HttpClientTestingModule,
        ToastrModule.forRoot(), 
        RouterTestingModule
      ],
      providers: [
        TorneosService
      ]
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CreateEditTorneoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});