import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Feedback } from 'src/app/models/feedback';
import { Jugador } from 'src/app/models/jugador';
import { FeedbackService } from 'src/app/service/feedback.service';
import { FeedbackEnum } from 'src/app/models/feedback_enum';

@Component({
  selector: 'app-feedback',
  templateUrl: './feedback.component.html',
  styleUrls: ['./feedback.component.css']
})
export class FeedbackComponent implements OnInit {
  feedbacks: Feedback[] = [];
  loading = false;
  selectedFeedback: Feedback | null = null;
  selectedUser: Jugador | null = null;
  categoria = FeedbackEnum;

  page = 1;
  pageSize = 10;
  hasNextPage = false;

  constructor(private feedbackService: FeedbackService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerFeedbacks();
  }

  obtenerFeedbacks() {
    this.loading = true;
    this.feedbackService.obtenerFeedbacks(this.page, this.pageSize).subscribe(
      (data) => {
        console.log('Feedbacks recibidos', data);
        console.log(data);
        this.feedbacks = data.items;
        this.hasNextPage = data.hasNextPage;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        if (error.status != 401) {
          this.toastr.error('Error al obtener feedbacks', 'Error');
        }
        console.error(error);
      }
    );
  }

  verUsuario(feedback: Feedback) {
    this.selectedFeedback = feedback;
    if (feedback.idUsuario != null) {
      this.feedbackService.obtenerUsuario(feedback.idUsuario).subscribe(
        (usuario) => {
          this.selectedUser = usuario;
        },
        (error) => {
          this.toastr.error('Error al obtener el usuario', 'Error');
        }
      );
    }
  }

  cerrarPopup() {
    this.selectedFeedback = null;
    this.selectedUser = null;
  }

  onPageChange(newPage: number) {
    if (newPage > 0 && (newPage < this.page || this.hasNextPage)) {
      this.page = newPage;
      this.obtenerFeedbacks();
    }
  }

  obtenerNombreCategoria(categoria: number): string {
    return FeedbackEnum[categoria];
  }
}
