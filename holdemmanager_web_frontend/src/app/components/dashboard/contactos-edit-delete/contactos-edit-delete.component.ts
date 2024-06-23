import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Contactos } from 'src/app/models/contactos';
import { ContactoService } from 'src/app/service/contacto.service';

@Component({
  selector: 'app-contactos-edit-delete',
  templateUrl: './contactos-edit-delete.component.html',
  styleUrls: ['./contactos-edit-delete.component.css']
})
export class ContactosEditDeleteComponent implements OnInit {
  contactos: Contactos[] = [];
  loading = false;

  constructor(private contactosService: ContactoService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerContactos();
  }

  obtenerContactos(): void {
    this.loading = true;
    this.contactosService.obtenerContactos().subscribe(
      (data) => {
        console.log('Contactos recibidos', data);
        console.log(data);
        this.contactos = data;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        this.toastr.error('Error al obtener contactos', 'Error');
        console.error(error);
      }
    );
  }

  eliminarContacto(id: number): void {
    if (confirm('¿Estás seguro de eliminar este contacto?')) {
      this.loading = true;
      this.contactosService.eliminarContacto(id).subscribe(
        () => {
          this.toastr.success('Contacto eliminado correctamente', 'Éxito');
          this.obtenerContactos(); //para que se actualice la lista despues de borrarlos
        },
        (error) => {
          this.loading = false;
          this.toastr.error('Error al eliminar el contacto', 'Error');
          console.error(error);
        }
      );
    }
  }

  editarContacto(contacto: Contactos): void {
    this.router.navigate(['/dashboard/contactos-edit', contacto.id]);
  }

}
