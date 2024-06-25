using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Domain.IServices
{
    public interface ILoginServiceApp
    {
        Task<Jugador> ValidateUser(Jugador usuario);
    }
}
