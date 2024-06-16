using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_web.Persistence.Repositories
{
    public class UsuarioRepositoryWeb : IUsuarioRepositoryWeb
    {
        private readonly AplicationDbContextWeb _context;
        public UsuarioRepositoryWeb(AplicationDbContextWeb context)
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
