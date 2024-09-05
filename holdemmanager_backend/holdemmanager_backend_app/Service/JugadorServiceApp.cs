using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Utils;
using Microsoft.EntityFrameworkCore;

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

        public async Task UpdateUser(int numeroJugador, Jugador jugadorActualizado)
        {
            await _usuarioRepository.UpdateUser(numeroJugador, jugadorActualizado);
        }

        public async Task<PagedResult<Jugador>> GetAllJugadores(int page, int pageSize, string filtro)
        {
            return await _usuarioRepository.GetAllJugadores(page, pageSize, filtro);
        }

        public async Task<Jugador> GetRecursoById(int id)
        {
           return await _usuarioRepository.GetJugadorById(id);
        }

        public async Task ActivateDeactivateNoticias(int id)
        {
            await _usuarioRepository.ActivateDeactivateNoticias(id);
        }
    }
}
