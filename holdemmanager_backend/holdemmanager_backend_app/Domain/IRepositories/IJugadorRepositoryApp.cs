using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Utils;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface IJugadorRepositoryApp
    {
        Task<PagedResult<Jugador>> GetAllJugadores(int page, int pageSize, string filtro);
        Task<Jugador> GetJugadorById(int id);
        Task SaveUser(Jugador usuario);
        Task<bool> ValidateExistence(Jugador usuario);
        Task<Jugador> ValidatePassword(int numberPlayer, string passwordAnterior);
        Task UpdateUsuario(Jugador usuario);
        Task DeleteUser(int id);
        Task UpdateUser(int numeroJugador, Jugador jugadorActualizado);

        Task ActivateDeactivateNoticias(int id);

    }
}
