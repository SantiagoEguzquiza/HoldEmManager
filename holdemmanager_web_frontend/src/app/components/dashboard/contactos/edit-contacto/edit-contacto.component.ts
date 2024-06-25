import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Contactos } from 'src/app/models/contactos';
import { ContactoService } from 'src/app/service/contacto.service';

@Component({
  selector: 'app-contactos-edit',
  templateUrl: './edit-contacto.component.html',
  styleUrls: ['./edit-contacto.component.css']
})
export class EditContactoComponent implements OnInit {

  contacto: Contactos | undefined;
  editForm: FormGroup;
  loading = false;

  constructor(private route: ActivatedRoute, private contactosService: ContactoService, private toastr: ToastrService, private router: Router, private fb: FormBuilder) {
    this.editForm = this.fb.group({
      infoCasino: ['', [Validators.required]],
      direccion: ['', [Validators.required]],
      email: ['', [Validators.required, Validators.email]],
      numeroTelefono: ['', [Validators.required, Validators.pattern(/^[0-9]*$/)]]
    })
  }

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.loading = true;
      this.contactosService.obtenerContactoPorId(Number(id)).subscribe(
        data => {
          this.contacto = data;
          this.editForm.patchValue(data);
          this.loading = false;
        },
        error => {
          console.error('Error al obtener contacto', error);
          this.loading = false;
        }
      );
    }
  }

  guardarCambios(): void {
    if (this.contacto?.id) {
      const updatedContacto = { ...this.contacto, ...this.editForm.value };
      this.contactosService.actualizarContacto(updatedContacto).subscribe(
        () => {
          this.toastr.success('Contacto actualizado correctamente', 'Éxito');
          this.router.navigate(['/dashboard/contactos-edit-delete']);
        },
        error => {
          this.toastr.error('Error al actualizar el contacto', 'Error');
          console.error('Error al actualizar contacto', error);
        }
      );
    } else {
      this.toastr.error('El contacto no tiene ID', 'Error');
      console.error('El contacto no tiene ID');
    }
  }


  cancelarEdicion(): void {
    this.toastr.info('Edicion cancelada');
    this.router.navigate(['/dashboard/contactos-edit-delete']);
  }

}
