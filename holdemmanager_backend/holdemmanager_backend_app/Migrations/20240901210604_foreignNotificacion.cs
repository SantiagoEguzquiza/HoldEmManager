using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    /// <inheritdoc />
    public partial class foreignNotificacion : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_NotificacionTorneos_Jugadores_JugadorId",
                table: "NotificacionTorneos");

            migrationBuilder.DropForeignKey(
                name: "FK_NotificacionTorneos_Torneos_TorneoId",
                table: "NotificacionTorneos");

            migrationBuilder.AddForeignKey(
                name: "FK_NotificacionTorneos_Jugadores_JugadorId",
                table: "NotificacionTorneos",
                column: "JugadorId",
                principalTable: "Jugadores",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_NotificacionTorneos_Torneos_TorneoId",
                table: "NotificacionTorneos",
                column: "TorneoId",
                principalTable: "Torneos",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_NotificacionTorneos_Jugadores_JugadorId",
                table: "NotificacionTorneos");

            migrationBuilder.DropForeignKey(
                name: "FK_NotificacionTorneos_Torneos_TorneoId",
                table: "NotificacionTorneos");

            migrationBuilder.AddForeignKey(
                name: "FK_NotificacionTorneos_Jugadores_JugadorId",
                table: "NotificacionTorneos",
                column: "JugadorId",
                principalTable: "Jugadores",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_NotificacionTorneos_Torneos_TorneoId",
                table: "NotificacionTorneos",
                column: "TorneoId",
                principalTable: "Torneos",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
