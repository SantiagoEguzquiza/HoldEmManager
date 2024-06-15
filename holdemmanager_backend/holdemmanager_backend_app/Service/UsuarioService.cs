using BackEnd.Domain.IRepositories;
using BackEnd.Domain.IServices;
using BackEnd.Domain.Models;

namespace BackEnd.Service
{
    public class UsuarioService : IUsuarioService
    {
        private readonly IUsuarioRepository _usuarioRepository;

        public UsuarioService(IUsuarioRepository usuarioRepository)
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
