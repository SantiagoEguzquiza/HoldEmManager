import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import Swal from 'sweetalert2';
import { NoticiasService } from 'src/app/service/noticias.service';
import { Noticia } from 'src/app/models/noticias';

@Component({
  selector: 'app-noticias',
  templateUrl: './noticias.component.html',
  styleUrls: ['./noticias.component.css']
})
export class NoticiasComponent implements OnInit {
  isCreateNoticia = false;
  noticias: Noticia[] = [];
  noticiaActual: Noticia | null = null;
  loading = false;
  page = 1;
  pageSize = 10;
  hasNextPage = false;

  constructor(private noticiasService: NoticiasService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerNoticias();
  }

  obtenerNoticias(): void {
    this.loading = true;
    this.noticiasService.obtenerNoticias(this.page, this.pageSize).subscribe(
      (data) => {
        this.noticias = data.items;
        this.hasNextPage = data.hasNextPage;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        this.toastr.error('Error al obtener noticias', 'Error');
      }
    );
  }

  eliminarNoticia(id: number): void {
    Swal.fire({
      title: '¿Estás seguro de eliminar esta noticia?',
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
    this.noticiaActual = null;
    this.isCreateNoticia = true;
  }

  editarNoticia(noticia: Noticia): void {
    this.noticiaActual = { ...noticia };
    this.isCreateNoticia = true;
  }

  guardarNuevaNoticia(nuevaNoticia: Noticia) {
    if (nuevaNoticia.id === 0 || nuevaNoticia.id === undefined) {
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
    } else {
      this.noticiasService.actualizarNoticia(nuevaNoticia).subscribe(
        (data) => {
          const index = this.noticias.findIndex(n => n.id === data.id);
          if (index !== -1) {
            this.noticias[index] = data;
          }
          this.toastr.success('Noticia actualizada exitosamente');
          this.isCreateNoticia = false;
          this.obtenerNoticias();
        },
        (error) => {
          this.toastr.error('Error al actualizar noticia', 'Error');
          console.error(error);
        }
      );
    }
  }

  cancelarNuevaNoticia() {
    this.isCreateNoticia = false;
  }

  onPageChange(newPage: number) {
    if (newPage > 0 && (newPage < this.page || this.hasNextPage)) {
      this.page = newPage;
      this.obtenerNoticias();
    }
  }
}