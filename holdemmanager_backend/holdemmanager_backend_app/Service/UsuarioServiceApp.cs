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
        public async Task SaveUser(Usuario usuario)
        {
            await _usuarioRepository.SaveUser(usuario);
        }

        public async Task<bool> ValidateExistence(Usuario usuario)
        {
            return await _usuarioRepository.ValidateExistence(usuario);
        }

        public async Task<Usuario> ValidatePassword(int numberPlayer, string passwordAnterior)
        {
            return await _usuarioRepository.ValidatePassword(numberPlayer, passwordAnterior);
        }

        public async Task UpdateUsuario(Usuario usuario)
        {
            await _usuarioRepository.UpdateUsuario(usuario);
        }
    }
}
