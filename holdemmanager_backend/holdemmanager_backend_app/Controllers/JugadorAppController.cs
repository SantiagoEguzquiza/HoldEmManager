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

        [HttpPost("activar-desactivar-noticias/{id}")]
        public async Task<IActionResult> ActivateDeactivateNoticias(int id)
        {
            await _usuarioService.ActivateDeactivateNoticias(id);
            return NoContent();
        }


        // obtener todos los jugadores
        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet]
        public async Task<ActionResult<PagedResult<Jugador>>> GetAllJugadores(int page, int pageSize, string filtro)
        {
            if (filtro == "NO")
            {
                filtro = "";
            }

            var jugadores = await _usuarioService.GetAllJugadores(page, pageSize, filtro);
            return Ok(jugadores);
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
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

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet("id/{id:int}")]
        public async Task<ActionResult<Jugador>> GetUsuarioPorId(int id) //trae jugador por id
        {
            try
            {
                var jugador = await _dbContext.Jugadores.Where(u => u.Id == id).FirstOrDefaultAsync();
                return Ok(jugador);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontraron datos que coincidan con el id." });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet("number/{numberPlayer:int}")]
        public async Task<ActionResult<Jugador>> GetUsuarioPorNumberPlayer(int numberPlayer) // trae jugador por numberPlayer
        {
            try
            {
                var jugador = await _dbContext.Jugadores
                    .Where(u => u.NumberPlayer == numberPlayer)
                    .FirstOrDefaultAsync();

                if (jugador == null)
                {
                    return NotFound(new { message = "No se encontraron datos que coincidan con el número de jugador." });
                }

                return Ok(jugador);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "Ocurrió un error al obtener los datos." });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet("Feedbacks/{userId:int}")]
        public async Task<ActionResult<List<Feedback>>> GetFeedbacksPorNumberPlayer(int userId) // trae feedbacks del jugador
        {
            try
            {
                var feedbacks = await _dbContext.Feedback
                    .Where(f => f.IdUsuario == userId)
                    .OrderByDescending(f => f.Fecha)
                    .Take(3)
                    .ToListAsync();

                if (feedbacks == null)
                {
                    return NotFound(new { message = "No se encontraron datos que coincidan con el número de jugador." });
                }

                return Ok(feedbacks);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "Ocurrió un error al obtener los datos." });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
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
            if (imageUrl != "null")
            {
                return Ok("Imagen guardada con exito");
            }
            else
            {
                return Ok("Imagen eliminada con exito");
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPut]
        public async Task<IActionResult> Put([FromBody] Jugador jugador)
        {
            try
            {
                await _usuarioService.UpdateUsuario(jugador);
                return Ok(new { message = "Usuario actualizado con éxito" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Ocurrió un error al actualizar el usuario", details = ex.Message });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
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
