using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    /// <inheritdoc />
    public partial class AddPlayerFeedback : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Feedback_Jugadores_JugadorId",
                table: "Feedback");

            migrationBuilder.DropIndex(
                name: "IX_Feedback_JugadorId",
                table: "Feedback");

            migrationBuilder.DropColumn(
                name: "JugadorId",
                table: "Feedback");

            migrationBuilder.AddColumn<int>(
                name: "UsuarioId",
                table: "Feedback",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Feedback_UsuarioId",
                table: "Feedback",
                column: "UsuarioId");

            migrationBuilder.AddForeignKey(
                name: "FK_Feedback_Jugadores_UsuarioId",
                table: "Feedback",
                column: "UsuarioId",
                principalTable: "Jugadores",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Feedback_Jugadores_UsuarioId",
                table: "Feedback");

            migrationBuilder.DropIndex(
                name: "IX_Feedback_UsuarioId",
                table: "Feedback");

            migrationBuilder.DropColumn(
                name: "UsuarioId",
                table: "Feedback");

            migrationBuilder.AddColumn<int>(
                name: "JugadorId",
                table: "Feedback",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Feedback_JugadorId",
                table: "Feedback",
                column: "JugadorId");

            migrationBuilder.AddForeignKey(
                name: "FK_Feedback_Jugadores_JugadorId",
                table: "Feedback",
                column: "JugadorId",
                principalTable: "Jugadores",
                principalColumn: "Id");
        }
    }
}
