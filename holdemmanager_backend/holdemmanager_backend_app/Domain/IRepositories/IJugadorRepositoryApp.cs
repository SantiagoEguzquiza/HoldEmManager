using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface IJugadorRepositoryApp
    {

        Task SaveUser(Jugador usuario);
        Task<bool> ValidateExistence(Jugador usuario);
        Task<Jugador> ValidatePassword(int numberPlayer, string passwordAnterior);
        Task UpdateUsuario(Jugador usuario);
        Task DeleteUser(int id);



    }
}
