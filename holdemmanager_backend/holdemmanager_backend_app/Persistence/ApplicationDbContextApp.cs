using holdemmanager_backend_app.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_app.Persistence
{
    public class AplicationDbContextApp : DbContext
    {
        public DbSet<Jugador> Jugadores { get; set; }
        public DbSet<Feedback> Feedbacks { get; set; }
        public DbSet<ForoDiscusion> ForoDiscusiones { get; set; }
        public DbSet<Mapa> Mapa { get; set; }
        public DbSet<Feedback> Feedback { get; set; }
        public AplicationDbContextApp(DbContextOptions<AplicationDbContextApp> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Feedback>()
                .HasOne<Jugador>()
                .WithMany()
                .HasForeignKey(f => f.IdUsuario)
                .OnDelete(DeleteBehavior.Cascade);
        }

    }
}
