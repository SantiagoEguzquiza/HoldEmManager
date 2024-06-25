/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { CreateContactoComponent } from './create-contacto.component';

describe('ContactoRegisterComponent', () => {
  let component: CreateContactoComponent;
  let fixture: ComponentFixture<CreateContactoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CreateContactoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CreateContactoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
