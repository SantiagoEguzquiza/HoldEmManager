import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import Swal from 'sweetalert2';
import { NoticiasService } from 'src/app/service/noticias.service';
import { Noticias } from 'src/app/models/noticias';

interface auxNoticia {
  id?: number;
  titulo: string;
  fecha: Date;
  mensaje: string;
  URLImagen?: string;
}

@Component({
  selector: 'app-noticias',
  templateUrl: './noticias.component.html',
  styleUrls: ['./noticias.component.css']
})
export class NoticiasComponent{

  isCreateNoticia = false;
  noticias: Noticias[] = [];
  loading = false;

  constructor(private noticiasService: NoticiasService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerNoticias();
  }

  obtenerNoticias(): void {
    this.loading = true;
    this.noticiasService.obtenerNoticias().subscribe(
      (data) => {
        this.noticias = data;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        this.toastr.error('Error al obtener noticias', 'Error');
        console.error(error);
      }
    );
  }

  eliminarNoticia(id: number): void {
    Swal.fire({
      title: '¿Estás seguro de eliminar esta noticia?',
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
        this.noticiasService.eliminarNoticia(id).subscribe(
          () => {
            this.toastr.success('Noticia eliminada correctamente', 'Éxito');
            this.obtenerNoticias();
          },
          (error) => {
            this.loading = false;
            this.toastr.error('Error al eliminar noticia', 'Error');
            console.error(error);
          }
        );
      }
    });
  }

  agregarNoticia() {
    this.isCreateNoticia = true;
  }

  editarNoticia(noticia: Noticias): void {
    //this.router.navigate(['/dashboard/edit-player', noticia.id]);
  }

  guardarNuevaNoticia(nuevaNoticia: auxNoticia) {

    this.noticiasService.agregarNoticia(nuevaNoticia).subscribe(
      (data) => {
        this.noticias.push(data);
        this.toastr.success('Noticia agregada exitosamente');
        this.isCreateNoticia = false;
        this.obtenerNoticias();
      },
      (error) => {
        this.toastr.error('Error al agregar noticia', 'Error');
        console.error(error);
      }
    );
  }

  cancelarNuevaNoticia() {
    this.isCreateNoticia = false;
  }

}
