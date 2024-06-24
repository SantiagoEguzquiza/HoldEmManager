using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface IUsuarioRepositoryApp
    {

        Task SaveUser(UsuarioApp usuario);
        Task<bool> ValidateExistence(UsuarioApp usuario);
        Task<UsuarioApp> ValidatePassword(int numberPlayer, string passwordAnterior);
        Task UpdateUsuario(UsuarioApp usuario);
        Task DeleteUser(int id);



    }
}
