import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Feedback } from 'src/app/models/feedback';
import { FeedbackService } from 'src/app/service/feedback.service';

@Component({
  selector: 'app-feedback',
  templateUrl: './feedback.component.html',
  styleUrls: ['./feedback.component.css']
})
export class FeedbackComponent implements OnInit {

  feedbacks: Feedback[] = [];
  loading = false;

  constructor(private feedbackService: FeedbackService, private router: Router, private toastr: ToastrService) { }

  ngOnInit() {
    this.obtenerFeedbacks();
  }


  obtenerFeedbacks() {
    this.loading = true;
    this.feedbackService.obtenerFeedbacks().subscribe(
      (data) => {
        console.log('Feedbacks recibidos', data);
        console.log(data);
        this.feedbacks = data;
        this.loading = false;
      },
      (error) => {
        this.loading = false;
        this.toastr.error('Error al obtener feedbacks', 'Error');
        console.error(error);
      }
    );
  }

  verUsuario(_t26: Feedback) {
    throw new Error('Method not implemented.');
    }
}
