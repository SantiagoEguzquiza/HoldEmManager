using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    /// <inheritdoc />
    public partial class AddFeedbackPlayer : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
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
        }
    }
}
