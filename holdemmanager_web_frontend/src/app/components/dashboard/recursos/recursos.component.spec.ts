/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { RecursosComponent } from '../../../app/components/recursos/recursos.component';

describe('RecursosEditDeleteComponent', () => {
  let component: RecursosComponent;
  let fixture: ComponentFixture<RecursosComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RecursosComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RecursosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
