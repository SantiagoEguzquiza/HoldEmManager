import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { ToastrModule } from 'ngx-toastr';
import { RouterTestingModule } from '@angular/router/testing';
import { MapaInteractivoComponent } from './mapa-interactivo.component';
import { MapaService } from 'src/app/service/mapa.service';

describe('MapaInteractivoComponent', () => {
  let component: MapaInteractivoComponent;
  let fixture: ComponentFixture<MapaInteractivoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [MapaInteractivoComponent],
      imports: [
        HttpClientTestingModule,
        ToastrModule.forRoot(),
        RouterTestingModule
      ],
      providers: [
        MapaService
      ]
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MapaInteractivoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});