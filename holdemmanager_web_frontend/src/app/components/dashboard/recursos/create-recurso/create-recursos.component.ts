import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { RecursosEducativos } from 'src/app/models/recursos';
import { RecursosService } from 'src/app/service/recursos.service';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { youtubeUrlValidator } from 'src/app/helpers/youtube-url.validator';

@Component({
  selector: 'app-create-recurso',
  templateUrl: './create-recursos.component.html',
  styleUrls: ['./create-recursos.component.css']
})
export class CreateRecursoComponent implements OnInit {
  register: FormGroup;
  loading = false;
  selectedFile?: File;
  selectedFileName?: string;
  @ViewChild('fileInput') fileInput?: ElementRef;

  constructor(private fb: FormBuilder, private recursosService: RecursosService, private router: Router, private toastr: ToastrService) {
    this.register = this.fb.group({
      titulo: ['', [Validators.required]],
      mensaje: ['', [Validators.required]],
      urlimagen: [''],
      urlvideo: ['', [youtubeUrlValidator()]]
    });
  }

  ngOnInit(): void {}

  crearRecurso(): void {
    const recurso: RecursosEducativos = {
      titulo: this.register.value.titulo,
      mensaje: this.register.value.mensaje,
      urlImagen: this.register.value.urlimagen,
      urlVideo: this.register.value.urlvideo
    };

    if (this.selectedFile) {
      this.convertirAByte(this.selectedFile, (base64Data) => {
        recurso.urlImagen = base64Data;
        this.saveRecurso(recurso);
      });
    } else {
      this.saveRecurso(recurso);
    }
  }

  saveRecurso(recurso: RecursosEducativos) {
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

  imagenSeleccionada(event: any): void {
    this.selectedFile = event.target.files[0];
    this.selectedFileName = this.selectedFile ? this.selectedFile.name : '';
  }

  convertirAByte(file: File, callback: (base64Data: string) => void): void {
    const reader = new FileReader();
    reader.onload = (e) => {
      const image = reader.result as string;
      const base64Data = image.split(',')[1];
      callback(base64Data);
    };
    reader.readAsDataURL(file);
  }

  triggerFileInput(): void {
    this.fileInput!.nativeElement.click();
  }
}