/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { EditContactoComponent } from './edit-contacto.component';

describe('ContactosEditComponent', () => {
  let component: EditContactoComponent;
  let fixture: ComponentFixture<EditContactoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EditContactoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EditContactoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
