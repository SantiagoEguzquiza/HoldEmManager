using holdemmanager_backend_web.Domain.Models;

namespace holdemmanager_backend_web.Domain.IRepositories
{
    public interface ILoginRepositoryWeb
    {
        Task<Usuario> ValidateUser(Usuario usuario);

    }
}
