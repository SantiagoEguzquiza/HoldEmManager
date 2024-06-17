using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_app.Persistence.Repositories
{
    public class UsuarioRepositoryApp : IUsuarioRepositoryApp
    {
        private readonly AplicationDbContextApp _context;
        public UsuarioRepositoryApp(AplicationDbContextApp context)
        {
            this._context = context;
        }

        public async Task SaveUser(UsuarioApp usuario)
        {
            _context.Add(usuario);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateUsuario(UsuarioApp usuario)
        {
            _context.Update(usuario);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> ValidateExistence(UsuarioApp usuario)
        {
            var validateExistence = await _context.Usuarios.AnyAsync(x => x.NumberPlayer == usuario.NumberPlayer);
            return validateExistence;
        }

        public async Task<UsuarioApp> ValidatePassword(int numberoJugador, string passwordAnterior)
        {
            var usuario = await _context.Usuarios.Where(x => x.NumberPlayer == numberoJugador && x.Password == passwordAnterior).FirstOrDefaultAsync();
            return usuario;
        }
    }
}
