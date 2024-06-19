import { Torneos } from "./Torneos";

export class UsuarioWeb {

    id?: number;
    nombreUsuario!: string;
    password!: string;
    listaTorneos?: Torneos[];
}