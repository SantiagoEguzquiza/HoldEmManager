/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { FeedbackPopupComponent } from './feedback-popup.component';

describe('FeedbackPopupComponent', () => {
  let component: FeedbackPopupComponent;
  let fixture: ComponentFixture<FeedbackPopupComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ FeedbackPopupComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(FeedbackPopupComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
