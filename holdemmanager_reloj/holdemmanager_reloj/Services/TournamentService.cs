using holdemmanager_reloj.Helpers;
using holdemmanager_reloj.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace holdemmanager_reloj.Services
{
    public class TournamentService
    {
        private readonly string _connectionString;
        private readonly DbContextOptions<ApplicationDbContext> _options;

        public TournamentService()
        {
            _connectionString = App.Configuration.GetConnectionString("DefaultConnection")!;
        }

        public TournamentService(DbContextOptions<ApplicationDbContext> options)
        {
            _options = options;
        }

        public async Task SaveOrUpdateTournament(Tournament tournament)
        {
            DbContextOptions<ApplicationDbContext> optionsToUse;

            if (_options != null)
            {
                optionsToUse = _options;
            }
            else
            {
                var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
                optionsBuilder.UseSqlServer(_connectionString);
                optionsToUse = optionsBuilder.Options;
            }

            using (var context = new ApplicationDbContext(optionsToUse))
            {
                var existingTournament = await context.Tournament
                    .FirstOrDefaultAsync(t => t.TournamentId == tournament.TournamentId);

                if (existingTournament != null)
                {
                    // Aquí aseguramos que Entity Framework rastree la entidad
                    context.Attach(existingTournament);

                    // Actualizamos manualmente los valores
                    existingTournament.TournamentName = tournament.TournamentName;
                    existingTournament.TotalEntries = tournament.TotalEntries;

                    // Forzamos a EF a marcar la entidad como modificada
                    context.Entry(existingTournament).State = EntityState.Modified;
                }
                else
                {
                    await context.Tournament.AddAsync(tournament);
                }

                await context.SaveChangesAsync();
            }
        }

        public async Task<List<Tournament>> ListTournamentAsync()
        {
            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseSqlServer(_connectionString);

            using (var context = new ApplicationDbContext(optionsBuilder.Options))
            {
                return context.Tournament.Include(t => t.Levels)
                                               .ToList();
            }
        }

        public void DeleteLevelsByTournamentId(int tournamentId)
        {

            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseSqlServer(_connectionString);

            using (var context = new ApplicationDbContext(optionsBuilder.Options))
            {
                var levels = context.BlindLevel.Where(l => l.TournamentId == tournamentId).ToList();

                context.BlindLevel.RemoveRange(levels);
                context.SaveChanges();
            }


        }

        public void DeleteTournament(Tournament tournament)
        {
            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseSqlServer(_connectionString);

            using (var context = new ApplicationDbContext(optionsBuilder.Options))
            {
                var tournament2 = context.Tournament.Find(tournament.TournamentId);
                context.Tournament.Remove(tournament2);
                context.SaveChanges();
            }
        }

        public void DeleteLevel(BlindLevel level)
        {
            if (level == null)
                throw new ArgumentNullException(nameof(level));

            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseSqlServer(_connectionString);

            using (var context = new ApplicationDbContext(optionsBuilder.Options))
            {
                var levelToDelete = context.BlindLevel.Find(level.BlindLevelId);
                if (levelToDelete != null)
                {
                    context.BlindLevel.Remove(levelToDelete);
                    context.SaveChanges();
                }
                else
                {
                    throw new InvalidOperationException("El nivel que intenta eliminar no existe en la base de datos.");
                }
            }
        }

        public void AddNewLevel(BlindLevel newLevel)
        {
            if (newLevel == null)
                throw new ArgumentNullException(nameof(newLevel));

            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseSqlServer(_connectionString);

            using (var context = new ApplicationDbContext(optionsBuilder.Options))
            {
                context.Entry(newLevel).State = EntityState.Added;

                context.SaveChanges();
            }
        }

        public void UpdateLevels(List<BlindLevel> updatedLevels)
        {
            if (updatedLevels == null || !updatedLevels.Any())
                throw new ArgumentNullException(nameof(updatedLevels));

            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseSqlServer(_connectionString);

            using (var context = new ApplicationDbContext(optionsBuilder.Options))
            {
                foreach (var level in updatedLevels)
                {
                    var existingLevel = context.BlindLevel.Find(level.BlindLevelId);
                    if (existingLevel != null)
                    {
                        context.Entry(existingLevel).CurrentValues.SetValues(level);
                    }
                }

                context.SaveChanges();
            }
        }

        public List<BlindLevel> GetLevelsByTournamentId(int tournamentId)
        {
            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseSqlServer(_connectionString);

            using (var context = new ApplicationDbContext(optionsBuilder.Options))
            {
                return context.BlindLevel.Where(l => l.TournamentId == tournamentId).ToList();
            }
        }
    }
}
