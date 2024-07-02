import { Component, EventEmitter, OnInit, Output } from '@angular/core';

@Component({
  selector: 'app-help',
  templateUrl: './help.component.html',
  styleUrls: ['./help.component.css']
})
export class HelpComponent implements OnInit {
  @Output() atras = new EventEmitter<void>();
  constructor() { }

  ngOnInit() {
  }
  atrasItem() {
    this.atras.emit();
  }
}
