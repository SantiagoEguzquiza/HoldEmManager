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

        public async Task SaveUser(UsuarioWeb usuario)
        {
            _context.Add(usuario);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateUsuario(UsuarioWeb usuario)
        {
            _context.Update(usuario);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> ValidateExistence(UsuarioWeb usuario)
        {
            var validateExistence = await _context.Usuarios.AnyAsync(x => x.NombreUsuario == usuario.NombreUsuario);
            return validateExistence;
        }

        public async Task<UsuarioWeb> ValidatePassword(string nombreUsuario, string passwordAnterior)
        {
            var usuario = await _context.Usuarios.Where(x => x.NombreUsuario == nombreUsuario && x.Password == passwordAnterior).FirstOrDefaultAsync();
            return usuario;
        }

        public async Task<UsuarioWeb> GetUsuario(int idUsuario)
        {
            var usuario = await _context.Usuarios.Where(u => u.Id == idUsuario).FirstOrDefaultAsync();
            return usuario;
        }
    }
}
