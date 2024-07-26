import { Component, Input, OnInit } from '@angular/core';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';
import { Feedback } from 'src/app/models/feedback';
import { User } from 'src/app/models/user'; // Asegúrate de tener un modelo de usuario

@Component({
  selector: 'app-user-feedback-popup',
  templateUrl: './user-feedback-popup.component.html',
  styleUrls: ['./user-feedback-popup.component.css']
})
export class UserFeedbackPopupComponent implements OnInit {
  @Input() feedback: Feedback | undefined;
  @Input() usuario: User | undefined;

  //constructor(public activeModal: NgbActiveModal) {}

  ngOnInit(): void {}

  close() {
    //this.activeModal.dismiss();
  }
}
