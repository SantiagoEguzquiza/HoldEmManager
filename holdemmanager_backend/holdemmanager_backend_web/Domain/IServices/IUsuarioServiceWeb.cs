using holdemmanager_backend_web.Domain.Models;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface IUsuarioServiceWeb
    {
        Task SaveUser(UsuarioWeb usuario);
        Task<bool> ValidateExistence(UsuarioWeb usuario);
        Task<UsuarioWeb> ValidatePassword(string nombreUsuario, string passwordAnterior);
        Task UpdateUsuario(UsuarioWeb usuario);
        Task<UsuarioWeb> GetUsuario(int idUsuario);
    }
}
