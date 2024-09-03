using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    /// <inheritdoc />
    public partial class notificacionesNoticias : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "NoticiasNotifications",
                table: "Jugadores",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.CreateTable(
                name: "NotificacionNoticias",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    JugadorId = table.Column<int>(type: "int", nullable: false),
                    TipoEvento = table.Column<int>(type: "int", nullable: false),
                    Fecha = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Mensaje = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NotificacionNoticias", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NotificacionNoticias_Jugadores_JugadorId",
                        column: x => x.JugadorId,
                        principalTable: "Jugadores",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_NotificacionNoticias_JugadorId",
                table: "NotificacionNoticias",
                column: "JugadorId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "NotificacionNoticias");

            migrationBuilder.DropColumn(
                name: "NoticiasNotifications",
                table: "Jugadores");
        }
    }
}
