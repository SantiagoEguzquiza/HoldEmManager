import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Contactos } from 'src/app/models/contactos';
import { ContactoService } from 'src/app/service/contacto.service';

@Component({
  selector: 'app-contacto-register',
  templateUrl: './contacto-register.component.html',
  styleUrls: ['./contacto-register.component.css']
})
export class ContactoRegisterComponent{
  register: FormGroup;
  loading = false;

  constructor(private fb: FormBuilder, private contactoService: ContactoService, private router: Router, private toastr: ToastrService) {

    this.register = this.fb.group({
      infocasino: ['', [Validators.required]],
      direccion: ['', [Validators.required]],
      numerotelefono: ['', [Validators.required, Validators.pattern(/^[0-9]*$/)]],
      email: ['', [Validators.required, Validators.email]]
    })
  }

  ngOnInit(): void{}

  crearContacto(): void {
    const contacto: Contactos = {
      infoCasino: this.register.value.infocasino,
      direccion: this.register.value.direccion,
      numeroTelefono: this.register.value.numerotelefono,
      email: this.register.value.email
    };

    this.loading = true;
    this.contactoService.saveContacto(contacto).subscribe(
      (data) => {
        console.log(data);
        this.toastr.success('El contacto fue agregado con exito!', 'Contacto Agregado!');
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
