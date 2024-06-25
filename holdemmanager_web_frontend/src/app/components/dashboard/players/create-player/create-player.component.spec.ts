import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RegisterPlayerComponent } from './create-player.component';

describe('RegisterComponent', () => {
  let component: RegisterPlayerComponent;
  let fixture: ComponentFixture<RegisterPlayerComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [RegisterPlayerComponent]
    });
    fixture = TestBed.createComponent(RegisterPlayerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
