import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Torneos } from 'src/app/models/torneos';
import { TorneosService } from 'src/app/service/torneos.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-torneos',
  templateUrl: './torneos.component.html',
  styleUrls: ['./torneos.component.css']
})
export class TorneosComponent implements OnInit {
  isCreateTorneo= false;
  torneos: Torneos[] = [];
  torneoActual: Torneos | null = null;
  loading = false;
  page = 1;
  pageSize = 10;
  hasNextPage = false;

  constructor(private torneosService: TorneosService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerTorneos();
  }

  obtenerTorneos(): void {
    this.loading = true;``
    this.torneosService.obtenerTorneos(this.page, this.pageSize).subscribe(
      (data) => {
        this.torneos = data.items;
        this.hasNextPage = data.hasNextPage;
        this.loading = false;
        console.log(data);
        console.log(data.items);
      },
      (error) => {
        this.loading = false;
        this.toastr.error('Error al obtener torneos', 'Error');
      }
    );
  }


  eliminarTorneo(id: number): void {
    Swal.fire({
      title: '¿Estás seguro de eliminar este torneo?',
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
        this.torneosService.eliminarTorneo(id).subscribe(
          () => {
            this.toastr.success('Torneo eliminado correctamente', 'Éxito');
            this.obtenerTorneos();
          },
          (error) => {
            this.loading = false;
            this.toastr.error('Error al eliminar torneo', 'Error');
            console.error(error);
          }
        );
      }
    });
  }


  agregarTorneo() {
    this.torneoActual = null;
    this.isCreateTorneo = true;
  }


  editarTorneo(torneo: Torneos): void {
    this.torneoActual = { ...torneo };
    this.isCreateTorneo = true;
  }


  guardarNuevoTorneo(nuevoTorneo: Torneos) {
    if (nuevoTorneo.id === 0 || nuevoTorneo.id === undefined) {
      this.torneosService.crearTorneo(nuevoTorneo).subscribe(
        (data) => {
          this.torneos.push(data);
          this.toastr.success('Torneo agregado exitosamente');
          this.isCreateTorneo = false;
          this.obtenerTorneos();
        },
        (error) => {
          this.toastr.error('Error al agregar torneo', 'Error');
          console.error(error);
        }
      );
    } else {
      this.torneosService.actualizarTorneo(nuevoTorneo).subscribe(
        (data) => {
          const index = this.torneos.findIndex(n => n.id === data.id);
          if (index !== -1) {
            this.torneos[index] = data;
          }
          this.toastr.success('Torneo actualizado exitosamente');
          this.isCreateTorneo = false;
          this.obtenerTorneos();
        },
        (error) => {
          this.toastr.error('Error al actualizar torneo', 'Error');
          console.error(error);
        }
      );
    }
  }


  cancelarNuevoTorneo() {
    this.isCreateTorneo = false;
  }


  onPageChange(newPage: number) {
    if (newPage > 0 && (newPage < this.page || this.hasNextPage)) {
      this.page = newPage;
      this.obtenerTorneos();
    }
  }
}
