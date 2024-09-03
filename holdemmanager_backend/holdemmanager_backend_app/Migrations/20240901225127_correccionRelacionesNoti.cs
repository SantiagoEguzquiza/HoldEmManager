using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    /// <inheritdoc />
    public partial class correccionRelacionesNoti : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_NotificacionTorneos_Torneos_TorneoId",
                table: "NotificacionTorneos");

            migrationBuilder.DropTable(
                name: "Torneos");

            migrationBuilder.DropIndex(
                name: "IX_NotificacionTorneos_TorneoId",
                table: "NotificacionTorneos");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Torneos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Cierre = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Entrada = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Fecha = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Inicio = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Niveles = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Nombre = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Stack = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    numeroRef = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Torneos", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_NotificacionTorneos_TorneoId",
                table: "NotificacionTorneos",
                column: "TorneoId");

            migrationBuilder.AddForeignKey(
                name: "FK_NotificacionTorneos_Torneos_TorneoId",
                table: "NotificacionTorneos",
                column: "TorneoId",
                principalTable: "Torneos",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
