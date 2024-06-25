/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { RecursosEditComponent } from './edit-recursos.component';

describe('RecursosEditComponent', () => {
  let component: RecursosEditComponent;
  let fixture: ComponentFixture<RecursosEditComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RecursosEditComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RecursosEditComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
