using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    public partial class actFeedbackYJugadores : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Eliminar la clave primaria actual
            migrationBuilder.DropPrimaryKey(
                name: "PK_Feedback",
                table: "Feedback");

            // Eliminar la clave foránea actual
            migrationBuilder.DropForeignKey(
                name: "FK_Feedback_Jugadores_Id",
                table: "Feedback");

            // Eliminar la columna Id existente
            migrationBuilder.DropColumn(
                name: "Id",
                table: "Feedback");

            // Volver a crear la columna Id con la configuración correcta
            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "Feedback",
                type: "int",
                nullable: false,
                defaultValue: 0)
                .Annotation("SqlServer:Identity", "1, 1"); // Configuración para identidad

            // Agregar la columna IdUsuario
            migrationBuilder.AddColumn<int>(
                name: "IdUsuario",
                table: "Feedback",
                type: "int",
                nullable: false,
                defaultValue: 0);

            // Crear un índice para la nueva columna IdUsuario
            migrationBuilder.CreateIndex(
                name: "IX_Feedback_IdUsuario",
                table: "Feedback",
                column: "IdUsuario");

            // Agregar la clave foránea para la nueva columna IdUsuario
            migrationBuilder.AddForeignKey(
                name: "FK_Feedback_Jugadores_IdUsuario",
                table: "Feedback",
                column: "IdUsuario",
                principalTable: "Jugadores",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            // Agregar la clave primaria a la nueva columna Id
            migrationBuilder.AddPrimaryKey(
                name: "PK_Feedback",
                table: "Feedback",
                column: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Eliminar la clave primaria y la clave foránea
            migrationBuilder.DropPrimaryKey(
                name: "PK_Feedback",
                table: "Feedback");

            migrationBuilder.DropForeignKey(
                name: "FK_Feedback_Jugadores_IdUsuario",
                table: "Feedback");

            // Eliminar la columna IdUsuario
            migrationBuilder.DropColumn(
                name: "IdUsuario",
                table: "Feedback");

            // Eliminar la columna Id con la configuración incorrecta
            migrationBuilder.DropColumn(
                name: "Id",
                table: "Feedback");

            // Volver a crear la columna Id con la configuración original (sin identidad)
            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "Feedback",
                type: "int",
                nullable: false,
                defaultValue: 0); // Sin configuración de identidad

            // Agregar la clave primaria original
            migrationBuilder.AddPrimaryKey(
                name: "PK_Feedback",
                table: "Feedback",
                column: "Id");

            // Agregar la clave foránea original
            migrationBuilder.AddForeignKey(
                name: "FK_Feedback_Jugadores_Id",
                table: "Feedback",
                column: "Id",
                principalTable: "Jugadores",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
