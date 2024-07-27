using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_web.Migrations
{
    /// <inheritdoc />
    public partial class ChangeIdNoticiaImagen : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "IdImagen",
                table: "Noticias",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IdImagen",
                table: "Noticias");
        }
    }
}
