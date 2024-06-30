using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.DTO;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_app.Utils;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;

namespace holdemmanager_backend_app.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class JugadorAppController : ControllerBase
    {
        private readonly IJugadorServiceApp _usuarioService;
        private readonly AplicationDbContextApp _dbContext;
        public JugadorAppController(AplicationDbContextApp dbContext, IJugadorServiceApp usuarioService)
        {

            _usuarioService = usuarioService;
            _dbContext = dbContext;
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Jugador usuario)
        {
            try
            {
                var usuarioExistente = await _usuarioService.ValidateExistence(usuario);
                if (usuarioExistente)
                {
                    return BadRequest(new { message = $"El numero de usuario {usuario.NumberPlayer} ya existe" });
                }

                usuario.Password = Encriptar.EncriptarPassword(usuario.Password);

                usuario.ImageUrl = null;

                await _usuarioService.SaveUser(usuario);


                return Ok(new { message = "Usuario registrado con éxito" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Ocurrió un error al registrar el usuario", details = ex.Message });
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
        public async Task<ActionResult<Jugador>> GetUsuarioPorNumeroJugador(int numeroJugador)
        {
            return await _dbContext.Jugadores.Where(u => u.NumberPlayer == numeroJugador).FirstOrDefaultAsync();
        }

        [HttpPut("{imageUrl}/{numeroJugador}")]
        public async Task<IActionResult> setImageUrl(string imageUrl, int numeroJugador)
        {
            var usuario = await _dbContext.Jugadores.Where(u => u.NumberPlayer == numeroJugador).FirstOrDefaultAsync();
            if (usuario == null)
            {
                return BadRequest("No existe el usuario");
            }

            usuario.ImageUrl = imageUrl;
            await _usuarioService.UpdateUsuario(usuario);
            if (imageUrl != "null" )
            {
                return Ok("Imagen guardada con exito");
            }
            else
            {
                return Ok("Imagen eliminada con exito");
            }
        }

        [HttpDelete("{numeroJugador}")]
        public async Task<IActionResult> Delete(int numeroJugador)
        {
            try
            {
                await _usuarioService.DeleteUser(numeroJugador);
                return Ok(new { message = "Usuario eliminado con éxito" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Ocurrió un error al eliminar el usuario", details = ex.Message });
            }
        }

    }
}
