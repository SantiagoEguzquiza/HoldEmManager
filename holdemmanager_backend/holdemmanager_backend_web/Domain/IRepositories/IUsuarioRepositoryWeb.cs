using holdemmanager_backend_web.Domain.Models;

namespace holdemmanager_backend_web.Domain.IRepositories
{
    public interface IUsuarioRepositoryWeb
    {

        Task SaveUser(Usuario usuario);
        Task<bool> ValidateExistence(Usuario usuario);
        Task<Usuario> ValidatePassword(int numberPlayer, string passwordAnterior);
        Task UpdateUsuario(Usuario usuario);



    }
}
