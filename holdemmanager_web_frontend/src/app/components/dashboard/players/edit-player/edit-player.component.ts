import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Jugador } from 'src/app/models/jugador';
import { PlayersService } from 'src/app/service/players.service';

@Component({
  selector: 'app-edit-player',
  templateUrl: './edit-player.component.html',
  styleUrls: ['./edit-player.component.css']
})
export class EditPlayerComponent implements OnInit {


  jugador: Jugador | undefined;
  editForm: FormGroup;
  loading = false;

  constructor(
    private route: ActivatedRoute,
    private playersService: PlayersService,
    private toastr: ToastrService,
    private router: Router,
    private fb: FormBuilder) {

    this.editForm = this.fb.group({
      numero: ['', Validators.required],
      nombre: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      urlimagen: ['']
    })

  }

  ngOnInit(): void {

    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.loading = true;
      
      this.playersService.obtenerPlayerPorId(Number(id)).subscribe(
        data => {
          this.jugador = data;
          this.editForm.patchValue({
            numero: data.numberPlayer,
            nombre: data.name,
            email: data.email,
            urlimagen: data.imageUrl,  
          });
          this.loading = false;
          
        },
        error => {
          console.error('Error al obtener recurso', error);
          this.loading = false;
        }
      );
    }
    
  }

  

  guardarCambios(): void {
    if (this.jugador?.id) {
      const updatedJugador = { ...this.jugador, ...this.editForm.value };
      this.playersService.actualizarJugador(updatedJugador).subscribe(
        () => {
          this.toastr.success('Jugador actualizado correctamente', 'Éxito');
          this.router.navigate(['/dashboard/players']);
        },
        error => {
          this.toastr.error('Error al actualizar el jugador', 'Error');
          console.error('Error al actualizar jugador', error);
        }
      );
    } else {
      this.toastr.error('El jugador no tiene ID', 'Error');
      console.error('El Jugador no tiene ID');
    }
  }
  

  cancelarEdicion(): void {
    this.toastr.info('Edicion cancelada');
    this.router.navigate(['/dashboard/players']);
  }

}
