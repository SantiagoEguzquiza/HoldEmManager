using holdemmanager_backend_app.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_app.Persistence
{
    public class AplicationDbContextApp : DbContext
    {
        public DbSet<UsuarioApp> Usuarios { get; set; }
        public DbSet<Feedback> Feedbacks { get; set; }
        public DbSet<ForoDiscusion> ForoDiscusiones { get; set; }
        public DbSet<Mapa> Mapa { get; set; }
        public AplicationDbContextApp(DbContextOptions<AplicationDbContextApp> options) : base(options)
        {
        }
    }
}
