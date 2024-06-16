using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace holdemmanager_backend_web.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class LoginAppController : ControllerBase
    {
        private readonly ILoginServiceWeb _loginService;
        private readonly IConfiguration _config;
        public LoginAppController(ILoginServiceWeb loginService, IConfiguration config)
        {
            _loginService = loginService;
            _config = config;
        }

        //[HttpPost]
        //public async Task<IActionResult> Post([FromBody] Usuario usuario)
        //{
        //    try
        //    {
        //        usuario.Password = Encriptar.EncriptarPassword(usuario.Password);
        //        var user = await _loginService.ValidateUser(usuario);
        //        if (user == null)
        //        {
        //            return BadRequest("playerUserInvalid");
        //        }

        //        string tokenString = JwtConfigurator.GetToken(user, _config);
        //        return Ok(new { token = tokenString });
        //    }
        //    catch (Exception ex)
        //    {

        //        return BadRequest(ex);
        //    }
        //}
    }
}
