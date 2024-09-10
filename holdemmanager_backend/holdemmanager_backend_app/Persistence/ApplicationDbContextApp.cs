using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_web.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_app.Persistence
{
    public class AplicationDbContextApp : DbContext
    {
        public DbSet<Jugador> Jugadores { get; set; }
        public DbSet<Feedback> Feedback { get; set; }
        public DbSet<ForoDiscusion> ForoDiscusiones { get; set; }
        public DbSet<Mapa> Mapa { get; set; }
        public DbSet<Favorito> Favoritos { get; set; }
        public DbSet<NotificacionTorneo> NotificacionTorneos { get; set; }

        public DbSet<NotificacionNoticia> NotificacionNoticias { get; set; }

        public AplicationDbContextApp(DbContextOptions<AplicationDbContextApp> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Feedback>()
                .HasOne<Jugador>()
                .WithMany()
                .HasForeignKey(f => f.IdUsuario)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<NotificacionTorneo>()
                .HasOne<Jugador>()
                .WithMany() 
                .HasForeignKey(j => j.JugadorId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<NotificacionNoticia>()
                .HasOne<Jugador>()
                .WithMany()
                .HasForeignKey(j => j.JugadorId)
                .OnDelete(DeleteBehavior.Restrict);

            base.OnModelCreating(modelBuilder);
        }
    }
}
