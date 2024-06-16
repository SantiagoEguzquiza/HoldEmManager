using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface IUsuarioRepositoryApp
    {

        Task SaveUser(Usuario usuario);
        Task<bool> ValidateExistence(Usuario usuario);
        Task<Usuario> ValidatePassword(int numberPlayer, string passwordAnterior);
        Task UpdateUsuario(Usuario usuario);



    }
}
