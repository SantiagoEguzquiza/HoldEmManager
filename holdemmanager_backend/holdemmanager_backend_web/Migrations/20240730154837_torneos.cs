using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_web.Migrations
{
    /// <inheritdoc />
    public partial class torneos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Horario",
                table: "Torneos",
                newName: "Fecha");

            migrationBuilder.AddColumn<string>(
                name: "ModoJuego",
                table: "Torneos",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ModoJuego",
                table: "Torneos");

            migrationBuilder.RenameColumn(
                name: "Fecha",
                table: "Torneos",
                newName: "Horario");
        }
    }
}
