using BackEnd.Domain.IRepositories;
using BackEnd.Domain.Models;
using holdemmanager_backend_app.Persistence;
using Microsoft.EntityFrameworkCore;

namespace BackEnd.Persistence.Repositories
{
    public class UsuarioRepository : IUsuarioRepository
    {

        private readonly AplicationDbContext _context;
        public UsuarioRepository(AplicationDbContext context)
        {
            this._context = context;
        }

        public async Task SaveUser(Usuario usuario)
        {
            _context.Add(usuario);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateUsuario(Usuario usuario)
        {
            _context.Update(usuario);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> ValidateExistence(Usuario usuario)
        {
            var validateExistence = await _context.Usuarios.AnyAsync(x => x.NumberPlayer == usuario.NumberPlayer);
            return validateExistence;
        }

        public async Task<Usuario> ValidatePassword(int numberoJugador, string passwordAnterior)
        {
            var usuario = await _context.Usuarios.Where(x => x.NumberPlayer == numberoJugador && x.Password == passwordAnterior).FirstOrDefaultAsync();
            return usuario;
        }
    }
}
