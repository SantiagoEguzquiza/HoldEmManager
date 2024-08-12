using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    /// <inheritdoc />
    public partial class UserIdNullFeedback : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Feedback_Jugadores_UsuarioId",
                table: "Feedback");

            migrationBuilder.AlterColumn<int>(
                name: "UsuarioId",
                table: "Feedback",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Feedback_Jugadores_UsuarioId",
                table: "Feedback",
                column: "UsuarioId",
                principalTable: "Jugadores",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Feedback_Jugadores_UsuarioId",
                table: "Feedback");

            migrationBuilder.AlterColumn<int>(
                name: "UsuarioId",
                table: "Feedback",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Feedback_Jugadores_UsuarioId",
                table: "Feedback",
                column: "UsuarioId",
                principalTable: "Jugadores",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
