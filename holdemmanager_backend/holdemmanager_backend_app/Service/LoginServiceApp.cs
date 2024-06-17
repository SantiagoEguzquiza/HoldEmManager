using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Service
{
    public class LoginServiceApp : ILoginServiceApp
    {
        private readonly ILoginRepositoryApp _loginRepository;
        public LoginServiceApp(ILoginRepositoryApp loginRepository)
        {

            _loginRepository = loginRepository;
        }

        public async Task<UsuarioApp> ValidateUser(UsuarioApp usuario)
        {
            return await _loginRepository.ValidateUser(usuario);
        }
    }
}
