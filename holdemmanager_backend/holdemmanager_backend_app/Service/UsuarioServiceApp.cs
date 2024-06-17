using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Service
{
    public class UsuarioServiceApp : IUsuarioServiceApp
    {
        private readonly IUsuarioRepositoryApp _usuarioRepository;

        public UsuarioServiceApp(IUsuarioRepositoryApp usuarioRepository)
        {

            _usuarioRepository = usuarioRepository;
        }
        public async Task SaveUser(UsuarioApp usuario)
        {
            await _usuarioRepository.SaveUser(usuario);
        }

        public async Task<bool> ValidateExistence(UsuarioApp usuario)
        {
            return await _usuarioRepository.ValidateExistence(usuario);
        }

        public async Task<UsuarioApp> ValidatePassword(int numberPlayer, string passwordAnterior)
        {
            return await _usuarioRepository.ValidatePassword(numberPlayer, passwordAnterior);
        }

        public async Task UpdateUsuario(UsuarioApp usuario)
        {
            await _usuarioRepository.UpdateUsuario(usuario);
        }
    }
}
