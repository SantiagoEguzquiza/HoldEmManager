using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_app.Migrations
{
    /// <inheritdoc />
    public partial class MapaPropiedades : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "URLImagen",
                table: "Mapa");

            migrationBuilder.AddColumn<byte[]>(
                name: "Plano",
                table: "Mapa",
                type: "varbinary(max)",
                nullable: false,
                defaultValue: new byte[0]);

            migrationBuilder.AddColumn<int>(
                name: "PlanoId",
                table: "Mapa",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Plano",
                table: "Mapa");

            migrationBuilder.DropColumn(
                name: "PlanoId",
                table: "Mapa");

            migrationBuilder.AddColumn<string>(
                name: "URLImagen",
                table: "Mapa",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}
