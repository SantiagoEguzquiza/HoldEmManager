import { Component, OnInit } from '@angular/core';
import { RecursoEducativo } from 'src/app/models/recursos';
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
  isCreateRecurso = false;
  recursos: RecursoEducativo[] = [];
  recursoActual: RecursoEducativo | null = null;
  loading = false;
  page = 1;
  pageSize = 10;
  hasNextPage = false;
  filtro = '';

  constructor(private recursoService: RecursosService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerRecursos();
  }

  obtenerRecursos(): void {
    this.loading = true;
    this.recursoService.obtenerRecursos(this.page, this.pageSize, this.filtro).subscribe(
      (data) => {
        this.recursos = data.items;
        this.hasNextPage = data.hasNextPage;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        this.toastr.error('Error al obtener recursos', 'Error');
        console.error(error);
      }
    );
  }

  agregarRecurso() {
    this.recursoActual = null;
    this.isCreateRecurso = true;
  }

  editarRecurso(recurso: RecursoEducativo): void {
    this.recursoActual = { ...recurso };
    this.isCreateRecurso = true;
  }

  guardarNuevoRecurso(nuevoRecurso: RecursoEducativo) {
    if (nuevoRecurso.id == null) {
      nuevoRecurso.id = 0;
    }
    if (nuevoRecurso.id === 0 || nuevoRecurso.id === undefined) {
      this.recursoService.agregarRecurso(nuevoRecurso).subscribe(
        (data) => {
          this.recursos.push(data);
          this.toastr.success('Recurso agregado exitosamente');
          this.isCreateRecurso = false;
          this.obtenerRecursos();
        },
        (error) => {
          this.toastr.error('Error al agregar recurso', 'Error');
          console.error(error);
        }
      );
    } else {
      this.recursoService.actualizarRecurso(nuevoRecurso).subscribe(
        (data) => {
          const index = this.recursos.findIndex(n => n.id === data.id);
          if (index !== -1) {
            this.recursos[index] = data;
          }
          this.toastr.success('Recurso actualizado exitosamente');
          this.isCreateRecurso = false;
          this.obtenerRecursos();
        },
        (error) => {
          this.toastr.error('Error al actualizar recurso', 'Error');
          console.error(error);
        }
      );
    }
  }

  eliminarRecurso(id: number): void {
    Swal.fire({
      title: '¿Estás seguro de eliminar este recurso?',
      text: 'No podrás revertir esta acción',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#b4540f',
      confirmButtonText: 'Sí, eliminar',
      cancelButtonText: 'Cancelar',
      customClass: {
        cancelButton: 'swal2-cancel-button',
        confirmButton: 'swal2-confirm-button'
      }
    }).then((result) => {
      if (result.isConfirmed) {
        this.loading = true;
        this.recursoService.eliminarRecurso(id).subscribe(
          () => {
            this.toastr.success('Recurso eliminado correctamente', 'Éxito');
            this.obtenerRecursos();
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

  cancelarNuevoRecurso() {
    this.isCreateRecurso = false;
  }

  onPageChange(newPage: number) {
    if (newPage > 0 && (newPage < this.page || this.hasNextPage)) {
      this.page = newPage;
      this.obtenerRecursos();
    }
  }

  aplicarFiltro(nuevoFiltro: string) {
    this.filtro = nuevoFiltro;
    this.page = 1;
    this.obtenerRecursos();
  }
}