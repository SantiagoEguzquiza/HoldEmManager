using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;

namespace holdemmanager_backend_web.Service
{
    public class LoginServiceWeb : ILoginServiceWeb
    {
        private readonly ILoginRepositoryWeb _loginRepository;
        public LoginServiceWeb(ILoginRepositoryWeb loginRepository)
        {

            _loginRepository = loginRepository;
        }

        public async Task<Usuario> ValidateUser(Usuario usuario)
        {
            return await _loginRepository.ValidateUser(usuario);
        }
    }
}
