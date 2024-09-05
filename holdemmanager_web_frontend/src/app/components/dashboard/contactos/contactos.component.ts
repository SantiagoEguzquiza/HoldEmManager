import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Contacto } from 'src/app/models/contactos';
import { ContactoService } from 'src/app/service/contacto.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-contactos',
  templateUrl: './contactos.component.html',
  styleUrls: ['./contactos.component.css']
})
export class ContactosComponent implements OnInit {
  isCreateContacto = false;
  contactos: Contacto[] = [];
  contactoActual: Contacto | null = null;
  loading = false;
  page = 1;
  pageSize = 10;
  hasNextPage = false;

  constructor(private contactosService: ContactoService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerContactos();
  }

  obtenerContactos(): void {
    this.loading = true;
    this.contactosService.obtenerContactos(this.page, this.pageSize).subscribe(
      (data) => {
        this.contactos = data.items;
        this.hasNextPage = data.hasNextPage;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        if (error.status != 401) {
          this.toastr.error('Error al obtener contactos', 'Error');
        }
      }
    );
  }

  eliminarContacto(id: number): void {
    Swal.fire({
      title: '¿Estás seguro de eliminar este contacto?',
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
        this.contactosService.eliminarContacto(id).subscribe(
          () => {
            this.toastr.success('Contacto eliminado correctamente', 'Éxito');
            this.obtenerContactos();
          },
          (error) => {
            this.loading = false;
            if (error.status != 401) {
              this.toastr.error('Error al eliminar el contacto', 'Error');
            }
          }
        );
      }
    });
  }

  agregarContacto() {
    this.contactoActual = null;
    this.isCreateContacto = true;
  }

  editarContacto(contacto: Contacto): void {
    this.contactoActual = { ...contacto };
    this.isCreateContacto = true;
  }

  guardarNuevoContacto(nuevoContacto: Contacto) {
    if (nuevoContacto.id === 0 || nuevoContacto.id === undefined) {
      this.contactosService.agregarContacto(nuevoContacto).subscribe(
        (data) => {
          this.toastr.success('Contacto agregado exitosamente');
          this.isCreateContacto = false;
          this.obtenerContactos();
        },
        (error) => {
          if (error.status != 401) {
            this.toastr.error('Error al agregar contacto', 'Error');
          }
        }
      );
    } else {
      this.contactosService.actualizarContacto(nuevoContacto).subscribe(
        (data) => {
          const index = this.contactos.findIndex(n => n.id === data.id);
          if (index !== -1) {
            this.contactos[index] = data;
          }
          this.toastr.success('Contacto actualizado exitosamente');
          this.isCreateContacto = false;
          this.obtenerContactos();
        },
        (error) => {
          if (error.status != 401) {
            this.toastr.error('Error al actualizar contacto', 'Error');
          }
        }
      );
    }
  }

  cancelarNuevoContacto() {
    this.isCreateContacto = false;
  }

  onPageChange(newPage: number) {
    if (newPage > 0 && (newPage < this.page || this.hasNextPage)) {
      this.page = newPage;
      this.obtenerContactos();
    }
  }
}