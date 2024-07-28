using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Utils;

namespace holdemmanager_backend_app.Domain.IServices
{
    public interface IJugadorServiceApp
    {
        Task<PagedResult<Jugador>> GetAllJugadores(int page, int pageSize);
        Task<Jugador> GetRecursoById(int id);
        Task SaveUser(Jugador usuario);
        Task<bool> ValidateExistence(Jugador usuario);
        Task<Jugador> ValidatePassword(int numberPlayer, string passwordAnterior);
        Task UpdateUsuario(Jugador usuario);
        Task DeleteUser(int numberPlayer);
        Task UpdateUser(int numberPlayer, Jugador jugadorActualizado);
    }
}
