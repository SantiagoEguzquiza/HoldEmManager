using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Service
{
    public class JugadorServiceApp : IJugadorServiceApp
    {
        private readonly IJugadorRepositoryApp _usuarioRepository;

        public JugadorServiceApp(IJugadorRepositoryApp usuarioRepository)
        {

            _usuarioRepository = usuarioRepository;
        }
        public async Task SaveUser(Jugador usuario)
        {
            await _usuarioRepository.SaveUser(usuario);
        }

        public async Task<bool> ValidateExistence(Jugador usuario)
        {
            return await _usuarioRepository.ValidateExistence(usuario);
        }

        public async Task<Jugador> ValidatePassword(int numberPlayer, string passwordAnterior)
        {
            return await _usuarioRepository.ValidatePassword(numberPlayer, passwordAnterior);
        }

        public async Task UpdateUsuario(Jugador usuario)
        {
            await _usuarioRepository.UpdateUsuario(usuario);
        }

        public async Task DeleteUser(int numeroJugador)
        {
            await _usuarioRepository.DeleteUser(numeroJugador);
        }
    }
}
