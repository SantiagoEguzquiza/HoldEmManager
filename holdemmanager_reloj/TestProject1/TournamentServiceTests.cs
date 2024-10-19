using Xunit;
using Microsoft.EntityFrameworkCore;
using holdemmanager_reloj.Models;
using holdemmanager_reloj.Services;
using System.Threading.Tasks;
using holdemmanager_reloj.Helpers;

public class TournamentServiceTests
{
    [Fact]
    public async Task SaveOrUpdateTournament_Should_AddNewTournament_When_TournamentDoesNotExist()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDatabase_Add")
            .Options;

        var service = new TournamentService(options);

        var newTournament = new Tournament
        {
            TournamentId = 1,
            TournamentName = "Test Tournament",
            TotalEntries = 100
        };

        // Act
        await service.SaveOrUpdateTournament(newTournament);

        // Assert
        using (var context = new ApplicationDbContext(options))
        {
            var tournament = await context.Tournament.FindAsync(1);
            Assert.NotNull(tournament);
            Assert.Equal("Test Tournament", tournament.TournamentName);
            Assert.Equal(100, tournament.TotalEntries);
        }
    }

    [Fact]
    public async Task SaveOrUpdateTournament_Should_UpdateExistingTournament_When_TournamentExists()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDatabase_Update")
            .Options;

        using (var context = new ApplicationDbContext(options))
        {
            var service = new TournamentService(options);

            var existingTournament = new Tournament
            {
                TournamentId = 1,
                TournamentName = "Existing Tournament",
                TotalEntries = 50
            };

            await context.Tournament.AddAsync(existingTournament);
            await context.SaveChangesAsync();
        }

        using (var context = new ApplicationDbContext(options))
        {
            var service = new TournamentService(options);
            var updatedTournament = new Tournament
            {
                TournamentId = 1,
                TournamentName = "Updated Tournament",
                TotalEntries = 150
            };

            await service.SaveOrUpdateTournament(updatedTournament);
        }

        using (var context = new ApplicationDbContext(options))
        {
            var tournament = await context.Tournament.FindAsync(1);
            Assert.NotNull(tournament);
            Assert.Equal("Updated Tournament", tournament.TournamentName);
            Assert.Equal(150, tournament.TotalEntries); 
        }
    }
}