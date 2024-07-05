using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface IJugadorRepositoryApp
    {

        Task<IEnumerable<Jugador>> GetAllJugadores();
        Task<Jugador> GetJugadorById(int id);
        Task SaveUser(Jugador usuario);
        Task<bool> ValidateExistence(Jugador usuario);
        Task<Jugador> ValidatePassword(int numberPlayer, string passwordAnterior);
        Task UpdateUsuario(Jugador usuario);
        Task DeleteUser(int id);
        Task UpdateUser(int numeroJugador, Jugador jugadorActualizado);



    }
}
