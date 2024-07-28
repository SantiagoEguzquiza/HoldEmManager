using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_app.Utils;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_app.Persistence.Repositories
{
    public class JugadorRepositoryApp : IJugadorRepositoryApp
    {
        private readonly AplicationDbContextApp _context;
        public JugadorRepositoryApp(AplicationDbContextApp context)
        {
            this._context = context;
        }

        public async Task<PagedResult<Jugador>> GetAllJugadores(int page, int pageSize)
        {
            var jugadores = await _context.Jugadores
                                 .Skip((page - 1) * pageSize)
                                 .Take(pageSize + 1)
                                 .ToListAsync();

            var hasNextPage = jugadores.Count > pageSize;

            if (hasNextPage)
            {
                jugadores.RemoveAt(pageSize);
            }

            return new PagedResult<Jugador>
            {
                Items = jugadores,
                HasNextPage = hasNextPage
            };
        }

        public async Task<Jugador> GetJugadorById(int id)
        {
            return await _context.Jugadores.FindAsync(id);
        }

        public async Task SaveUser(Jugador usuario)
        {
            _context.Add(usuario);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateUsuario(Jugador usuario)
        {
            _context.Update(usuario);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> ValidateExistence(Jugador usuario)
        {
            var validateExistence = await _context.Jugadores.AnyAsync(x => x.NumberPlayer == usuario.NumberPlayer);
            return validateExistence;
        }

        public async Task<Jugador> ValidatePassword(int numberoJugador, string passwordAnterior)
        {
            var usuario = await _context.Jugadores.Where(x => x.NumberPlayer == numberoJugador && x.Password == passwordAnterior).FirstOrDefaultAsync();
            return usuario;
        }

        public async Task DeleteUser(int numeroJugador)
        {
            var usuario = await _context.Jugadores.Where(u => u.NumberPlayer == numeroJugador).FirstOrDefaultAsync();
            if (usuario != null)
            {
                _context.Jugadores.Remove(usuario);
                await _context.SaveChangesAsync();
            }
        }

        public async Task UpdateUser(int id, Jugador usuarioActualizado)
        {
            var usuario = await _context.Jugadores.Where(u => u.Id == id).FirstOrDefaultAsync();
            if (usuario != null)
            {
                usuario.NumberPlayer = usuarioActualizado.NumberPlayer;
                usuario.Name = usuarioActualizado.Name ?? usuario.Name;
                usuario.Email = usuarioActualizado.Email ?? usuario.Email;
                usuario.Password = usuarioActualizado.Password != null ? Encriptar.EncriptarPassword(usuarioActualizado.Password) : usuario.Password;
                usuario.ImageUrl = usuarioActualizado.ImageUrl ?? usuario.ImageUrl;

                _context.Jugadores.Update(usuario);
                await _context.SaveChangesAsync();
            }
        }

        
    }
}
