using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.DTO;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Utils;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace holdemmanager_backend_web.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class UsuarioWebController : ControllerBase
    {
        private readonly IUsuarioServiceWeb _usuarioService;
        private readonly AplicationDbContextWeb _dbContext;
        public UsuarioWebController(AplicationDbContextWeb dbContext, IUsuarioServiceWeb usuarioService)
        {

            _usuarioService = usuarioService;
            _dbContext = dbContext;
        }

        [HttpGet("GetUsuario")]
        public async Task<ActionResult<UsuarioWeb>> GetUsuarioLoggeado()
        {
            try
            {
                var identity = HttpContext.User.Identity as ClaimsIdentity;

                int idUsuario = JwtConfigurator.GetTokenIdUsuario(identity);

                if (idUsuario == null) {
                    return BadRequest("No se pudo encontrar el usuario");
                }

                return await _usuarioService.GetUsuario(idUsuario);
            }
            catch (Exception ex) { 
                return BadRequest(ex.Message);  
            }
           
        }

    }
}
