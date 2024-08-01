using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_web.Migrations
{
    /// <inheritdoc />
    public partial class actTorneos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Premios",
                table: "Torneos",
                newName: "numeroRef");

            migrationBuilder.RenameColumn(
                name: "ModoJuego",
                table: "Torneos",
                newName: "Stack");

            migrationBuilder.AddColumn<string>(
                name: "Cierre",
                table: "Torneos",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Entrada",
                table: "Torneos",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Inicio",
                table: "Torneos",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Niveles",
                table: "Torneos",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Cierre",
                table: "Torneos");

            migrationBuilder.DropColumn(
                name: "Entrada",
                table: "Torneos");

            migrationBuilder.DropColumn(
                name: "Inicio",
                table: "Torneos");

            migrationBuilder.DropColumn(
                name: "Niveles",
                table: "Torneos");

            migrationBuilder.RenameColumn(
                name: "numeroRef",
                table: "Torneos",
                newName: "Premios");

            migrationBuilder.RenameColumn(
                name: "Stack",
                table: "Torneos",
                newName: "ModoJuego");
        }
    }
}
