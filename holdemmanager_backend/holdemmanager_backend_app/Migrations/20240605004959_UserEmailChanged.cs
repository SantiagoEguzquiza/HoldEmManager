using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    /// <inheritdoc />
    public partial class UserEmailChanged : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "NombreUsuario",
                table: "Usuarios",
                newName: "Email");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Email",
                table: "Usuarios",
                newName: "NombreUsuario");
        }
    }
}
