using holdemmanager_backend_app.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_app.Persistence
{
    public class AplicationDbContextApp : DbContext
    {
        public DbSet<UsuarioApp> Usuarios { get; set; }
        public AplicationDbContextApp(DbContextOptions<AplicationDbContextApp> options) : base(options)
        {
        }
    }
}
