using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.IServices;

namespace holdemmanager_backend_web.Service
{
    public class UsuarioServiceWeb : IUsuarioServiceWeb
    {
        private readonly IUsuarioRepositoryWeb _usuarioRepository;

        public UsuarioServiceWeb(IUsuarioRepositoryWeb usuarioRepository)
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
