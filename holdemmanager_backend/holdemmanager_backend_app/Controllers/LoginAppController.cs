using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace holdemmanager_backend_app.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class LoginAppController : ControllerBase
    {
        private readonly ILoginServiceApp _loginService;
        private readonly IConfiguration _config;
        public LoginAppController(ILoginServiceApp loginService, IConfiguration config)
        {
            _loginService = loginService;
            _config = config;
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Jugador usuario)
        {
            try
            {
                usuario.Password = Encriptar.EncriptarPassword(usuario.Password);
                var user = await _loginService.ValidateUser(usuario);
                if (user == null)
                {
                    return BadRequest("playerUserInvalid");
                }

                string tokenString = JwtConfigurator.GetToken(user, _config);
                return Ok(new { token = tokenString });
            }
            catch (Exception ex)
            {

                return BadRequest(ex);
            }
        }
    }
}
