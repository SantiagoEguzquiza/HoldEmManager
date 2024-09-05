using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace holdemmanager_backend_web.Migrations
{
    /// <inheritdoc />
    public partial class ChangesDetails : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Noticia",
                table: "Noticia");

            migrationBuilder.RenameTable(
                name: "Noticia",
                newName: "Noticias");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Noticias",
                table: "Noticias",
                column: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Noticias",
                table: "Noticias");

            migrationBuilder.RenameTable(
                name: "Noticias",
                newName: "Noticia");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Noticia",
                table: "Noticia",
                column: "Id");
        }
    }
}
