using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface ILoginRepositoryApp
    {
        Task<UsuarioApp> ValidateUser(UsuarioApp usuario);

    }
}
