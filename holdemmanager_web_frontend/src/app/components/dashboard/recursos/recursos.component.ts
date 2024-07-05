import { Component, OnInit } from '@angular/core';
import { RecursosEducativos } from 'src/app/models/recursos';
import { RecursosService } from 'src/app/service/recursos.service';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-recursos',
  templateUrl: './recursos.component.html',
  styleUrls: ['./recursos.component.css']
})
export class RecursosComponent implements OnInit {
  recursos: RecursosEducativos[] = [];
  loading = false;

  constructor(private recursosService: RecursosService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerRecursos();
  }

  obtenerRecursos(): void {
    this.loading = true;
    this.recursosService.obtenerRecursos().subscribe(
      (data) => {
        console.log(data);
        this.recursos = data;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        this.toastr.error('Error al obtener recursos', 'Error');
        console.error(error);
      }
    );
  }

  eliminarRecurso(id: number): void {
    Swal.fire({
      title: '¿Estás seguro de eliminar este recurso?',
      text: 'No podrás revertir esta acción',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#f59f00', 
      confirmButtonText: 'Sí, eliminar',
      cancelButtonText: 'Cancelar',
      customClass: {
        cancelButton: 'swal2-cancel-button', 
        confirmButton: 'swal2-confirm-button' 
      }
    }).then((result) => {
      if (result.isConfirmed) {
        this.loading = true;
        this.recursosService.eliminarRecurso(id).subscribe(
          () => {
            this.toastr.success('Recurso eliminado correctamente', 'Éxito');
            this.obtenerRecursos(); // para que se actualice la lista después de borrarlos
          },
          (error) => {
            this.loading = false;
            this.toastr.error('Error al eliminar el recurso', 'Error');
            console.error(error);
          }
        );
      }
    });
  }

  editarRecurso(recurso: RecursosEducativos): void {
    this.router.navigate(['/dashboard/edit-recurso', recurso.id]);
  }

}