using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    /// <inheritdoc />
    public partial class idFeedbackNull : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Feedback_Jugadores_IdUsuario",
                table: "Feedback");

            migrationBuilder.AddForeignKey(
                name: "FK_Feedback_Jugadores_IdUsuario",
                table: "Feedback",
                column: "IdUsuario",
                principalTable: "Jugadores",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Feedback_Jugadores_IdUsuario",
                table: "Feedback");

            migrationBuilder.AddForeignKey(
                name: "FK_Feedback_Jugadores_IdUsuario",
                table: "Feedback",
                column: "IdUsuario",
                principalTable: "Jugadores",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
