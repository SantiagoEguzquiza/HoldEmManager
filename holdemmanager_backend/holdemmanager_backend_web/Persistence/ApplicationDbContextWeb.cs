using holdemmanager_backend_web.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_web.Persistence
{
    public class AplicationDbContextWeb : DbContext
    {
        public DbSet<UsuarioWeb> Usuarios { get; set; }
        public DbSet<Torneos> Torneos { get; set; }
        public DbSet<Noticia> ForoNoticias { get; set; }
        public DbSet<RecursoEducativo> RecursosEducativos { get; set; }

        public DbSet<Noticia> Noticias { get; set; }

        public DbSet<Contacto> Contactos { get; set; }

        public AplicationDbContextWeb(DbContextOptions<AplicationDbContextWeb> options) : base(options)
        {
        }
    }
}
