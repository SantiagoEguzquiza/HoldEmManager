using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_web.Persistence.Repositories
{
    public class LoginRepositoryWeb : ILoginRepositoryWeb
    {
        private readonly AplicationDbContextWeb _context;
        public LoginRepositoryWeb(AplicationDbContextWeb context)
        {
            _context = context;
        }

        public async Task<UsuarioWeb> ValidateUser(UsuarioWeb usuario)
        {
            var user = await _context.Usuarios.Where(x => x.NombreUsuario == usuario.NombreUsuario && x.Password == usuario.Password).FirstOrDefaultAsync();
            return user;
        }
    }
}
