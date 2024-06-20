using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;

namespace holdemmanager_backend_web.Service
{
    public class UsuarioServiceWeb : IUsuarioServiceWeb
    {
        private readonly IUsuarioRepositoryWeb _usuarioRepository;

        public UsuarioServiceWeb(IUsuarioRepositoryWeb usuarioRepository)
        {

            _usuarioRepository = usuarioRepository;
        }
        public async Task SaveUser(UsuarioWeb usuario)
        {
            await _usuarioRepository.SaveUser(usuario);
        }

        public async Task<bool> ValidateExistence(UsuarioWeb usuario)
        {
            return await _usuarioRepository.ValidateExistence(usuario);
        }

        public async Task<UsuarioWeb> ValidatePassword(string nombreUsuario, string passwordAnterior)
        {
            return await _usuarioRepository.ValidatePassword(nombreUsuario, passwordAnterior);
        }

        public async Task UpdateUsuario(UsuarioWeb usuario)
        {
            await _usuarioRepository.UpdateUsuario(usuario);
        }

        public async Task<UsuarioWeb> GetUsuario(int idUsuario)
        {
            return await _usuarioRepository.GetUsuario(idUsuario);
        }
    }
}
