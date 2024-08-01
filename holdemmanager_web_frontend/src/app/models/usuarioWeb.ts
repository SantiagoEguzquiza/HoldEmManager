import { RolesEnum } from "./roles";
import { Torneos } from "./torneos";

export class UsuarioWeb {

    id?: number;
    nombreUsuario!: string;
    password!: string;
    listaTorneos?: Torneos[];
    rol?: RolesEnum;
}