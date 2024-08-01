using holdemmanager_backend_web.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_web.Persistence
{
    public class AplicationDbContextWeb : DbContext
    {
        public DbSet<UsuarioWeb> Usuarios { get; set; }
        public DbSet<Torneos> Torneos { get; set; }
        public DbSet<Noticias> ForoNoticias { get; set; }
        public DbSet<RecursosEducativos> RecursosEducativos { get; set; }
        public DbSet<Noticias> Noticias { get; set; }
        public DbSet<Contacto> Contactos { get; set; }
        public DbSet<Ranking> Rankings { get; set; }
        public AplicationDbContextWeb(DbContextOptions<AplicationDbContextWeb> options) : base(options)
        {
        }
    }
}
