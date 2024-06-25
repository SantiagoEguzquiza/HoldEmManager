import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { RecursosEducativos } from 'src/app/models/recursos';
import { RecursosService } from 'src/app/service/recursos.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-edit-recurso',
  templateUrl: './edit-recursos.component.html',
  styleUrls: ['./edit-recursos.component.css']
})
export class EditRecursosComponent implements OnInit {

  recurso: RecursosEducativos | undefined;
  editForm: FormGroup;
  loading = false;

  constructor(private route: ActivatedRoute, private recursosService: RecursosService, private toastr: ToastrService, private router: Router, private fb: FormBuilder) 
  {
    this.editForm = this.fb.group({
      titulo: ['', Validators.required],
      mensaje: ['', Validators.required],
      urlimagen: ['']
    })
  }

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.loading = true;
      this.recursosService.obtenerRecursoPorId(Number(id)).subscribe(
        data => {
          this.recurso = data;
          this.editForm.patchValue(data);
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
    if (this.recurso?.id) {
      const updatedRecurso = { ...this.recurso, ...this.editForm.value };
      this.recursosService.actualizarRecurso(updatedRecurso).subscribe(
        () => {
          this.toastr.success('Recurso actualizado correctamente', 'Éxito');
          this.router.navigate(['/dashboard/recursos-edit-delete']);
        },
        error => {
          this.toastr.error('Error al actualizar el recurso', 'Error');
          console.error('Error al actualizar recurso', error);
        }
      );
    } else {
      this.toastr.error('El recurso no tiene ID', 'Error');
      console.error('El recurso no tiene ID');
    }
  }

  cancelarEdicion(): void {
    this.toastr.info('Edicion cancelada');
    this.router.navigate(['/dashboard/recursos-edit-delete']);
  }
}
