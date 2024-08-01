import { FeedbackEnum } from "./feedback_enum";

export class Feedback{
    id!:number;
    idUsuario!: number;
    fecha!: Date;
    mensaje!: string;
    categoria!: FeedbackEnum;
    isAnonimo!: boolean;
}