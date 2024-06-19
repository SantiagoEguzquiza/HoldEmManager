import { UsuarioWeb } from "./usuarioWeb";

export class Torneos {

    id?: number;
    nombre!: string;
    horario!: Date;
    premios!: string;
    listaJugadores!: UsuarioWeb[];
}