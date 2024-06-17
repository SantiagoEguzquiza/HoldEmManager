using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_app.Persistence.Repositories
{
    public class LoginRepositoryApp : ILoginRepositoryApp
    {
        private readonly AplicationDbContextApp _context;
        public LoginRepositoryApp(AplicationDbContextApp context)
        {
            _context = context;
        }

        public async Task<UsuarioApp> ValidateUser(UsuarioApp usuario)
        {
            var user = await _context.Usuarios.Where(x => x.NumberPlayer == usuario.NumberPlayer && x.Password == usuario.Password).FirstOrDefaultAsync();
            return user;
        }
    }
}
