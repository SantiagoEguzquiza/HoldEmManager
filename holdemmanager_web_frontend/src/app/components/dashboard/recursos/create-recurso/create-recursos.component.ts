import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { RecursosEducativos } from 'src/app/models/recursos';
import { RecursosService } from 'src/app/service/recursos.service';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-recursos-register',
  templateUrl: './create-recursos.component.html',
  styleUrls: ['./create-recursos.component.css']
})
export class CreateRecursoComponent {
  register: FormGroup;
  loading = false;

  constructor(private fb: FormBuilder, private recursosService: RecursosService, private router: Router, private toastr: ToastrService) {

    this.register = this.fb.group({
      titulo: ['', [Validators.required]],
      mensaje: ['', [Validators.required]],
      urlimagen: ['']
    })
  }

  ngOnInit(): void { }

  crearRecurso(): void {
    const recurso: RecursosEducativos = {
      titulo: this.register.value.titulo,
      mensaje: this.register.value.mensaje,
      URLImagen: this.register.value.urlimagen,
    };

    this.loading = true;
    this.recursosService.saveRecurso(recurso).subscribe(
      (data) => {
        console.log(data);
        this.toastr.success('El recurso fue agregado con exito!', 'Recurso Agregado!');
        this.router.navigate(['/dashboard/home']);
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        this.register.reset(); 
        this.toastr.error(error.error.message, 'Error!');
        console.log(error);
      }
    );
  }

}

