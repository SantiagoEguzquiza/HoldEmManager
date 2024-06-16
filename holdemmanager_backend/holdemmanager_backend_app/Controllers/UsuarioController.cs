using BackEnd.Domain.IServices;
using BackEnd.Domain.Models;
using BackEnd.DTO;
using BackEnd.Utils;
using holdemmanager_backend_app.Persistence;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace BackEnd.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class UsuarioController : ControllerBase
    {
        private readonly IUsuarioService _usuarioService;
        private readonly AplicationDbContext _dbContext;
        public UsuarioController(AplicationDbContext dbContext, IUsuarioService usuarioService)
        {

            _usuarioService = usuarioService;
            _dbContext = dbContext;
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Usuario usuario)
        {
            try
            {
                var validateExistence = await _usuarioService.ValidateExistence(usuario);
                if (validateExistence)
                {
                    return BadRequest($"El número de jugador {usuario.NumberPlayer} ya existe");
                }

                usuario.Password = Encriptar.EncriptarPassword(usuario.Password);
                await _usuarioService.SaveUser(usuario);

                return Ok("Usuario registrado con exito");
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message);

            }

        }

        
        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPut("CambiarPassword")]
        public async Task<IActionResult> CambiarPassword([FromBody] CambiarPasswordDTO cambiarPassword)
        {
            try
            {
                var identity = HttpContext.User.Identity as ClaimsIdentity;

                int numberPlayer = JwtConfigurator.GetTokenNumberPlayer(identity);
                string passwordEncriptado = Encriptar.EncriptarPassword(cambiarPassword.passwordAnterior);
                var usuario = await _usuarioService.ValidatePassword(numberPlayer, passwordEncriptado);

                if (usuario == null)
                {

                    return BadRequest(new { message = "Password incorrecta" });

                }
                else
                {

                    usuario.Password = Encriptar.EncriptarPassword(cambiarPassword.nuevaPassword);
                    await _usuarioService.UpdateUsuario(usuario);
                    return Ok(new { message = "La password fue actualizada con exito" });

                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message);
            }

        }

        [HttpGet("{numeroJugador}")]
        public async Task<ActionResult<Usuario>> GetUsuarioPorNumeroJugador(int numeroJugador)
        {
            return await _dbContext.Usuarios.Where(u => u.NumberPlayer == numeroJugador).FirstOrDefaultAsync();
        }

        [HttpPut("{imageUrl}/{numeroJugador}")]
        public async Task<IActionResult> setImageUrl(string imageUrl, int numeroJugador)
        {
            var usuario = await _dbContext.Usuarios.Where(u => u.NumberPlayer == numeroJugador).FirstOrDefaultAsync();
            if (usuario == null) {
                return BadRequest("No existe el usuario");
            }

            usuario.ImageUrl = imageUrl;
            await _usuarioService.UpdateUsuario(usuario);

            return Ok("Imagen guardada con exito");
        }

    }
}
