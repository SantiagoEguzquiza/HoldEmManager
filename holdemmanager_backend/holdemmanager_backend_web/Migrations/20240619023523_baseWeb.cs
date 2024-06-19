using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_web.Migrations
{
    /// <inheritdoc />
    public partial class baseWeb : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ForoNoticias",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Fecha = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Mensaje = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    URLImagen = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ForoNoticias", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "RecursosEducativos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Mensaje = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    URLImagen = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecursosEducativos", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Torneos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Nombre = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Horario = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Premios = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Torneos", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "TorneosUsuarioWeb",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TorneosUsuarioWeb", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TorneosUsuarioWeb_Torneos_Id",
                        column: x => x.Id,
                        principalTable: "Torneos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_TorneosUsuarioWeb_Usuarios_Id",
                        column: x => x.Id,
                        principalTable: "Usuarios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ForoNoticias");

            migrationBuilder.DropTable(
                name: "RecursosEducativos");

            migrationBuilder.DropTable(
                name: "TorneosUsuarioWeb");

            migrationBuilder.DropTable(
                name: "Torneos");
        }
    }
}
