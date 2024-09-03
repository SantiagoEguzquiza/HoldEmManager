using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_web.Domain.IServices;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class NotificacionNoticiaAppController : ControllerBase
    {
        private readonly INotificacionNoticiasWeb _notificacionService;
        private readonly AplicationDbContextApp _dbContext;
        public NotificacionNoticiaAppController(INotificacionNoticiasWeb notificacionService, AplicationDbContextApp dbContext)
        {
            _notificacionService = notificacionService;
            _dbContext = dbContext;
        }

        [HttpGet("jugador/{idJugador}")]
        public async Task<ActionResult<List<NotificacionNoticia>>> GetNotificacionesPorJugador(int idJugador)
        {
            var notificaciones = await _dbContext.NotificacionNoticias
                .Where(n => n.JugadorId == idJugador)
                .ToListAsync();

            if (notificaciones == null || notificaciones.Count == 0)
            {
                return NotFound("No se encontraron notificaciones para este jugador.");
            }

            return Ok(notificaciones);
        }

        [HttpPost]
        public async Task<IActionResult> AddNotificacion(int noticiaId, string tipoEvento)
        {
            try
            {
                await _notificacionService.AddNotificacion(noticiaId, tipoEvento);
                return Ok("Notificaciones generadas con éxito.");
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Ocurrió un error al generar las notificaciones: {ex.Message}" });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteNotificacion(int id)
        {
            try
            {
                var notificacion = await _notificacionService.DeleteNotificacion(id);
                if (!notificacion)
                {
                    return BadRequest(new { message = "La notificacion no existe." });
                }

                var deleteResult = await _notificacionService.DeleteNotificacion(id);
                if (deleteResult)
                {
                    return Ok(new { message = "Notificacion eliminada exitosamente." });
                }
                else
                {
                    return BadRequest(new { message = "No se pudo eliminar la notificacion." });
                }
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Ocurrió un error al intentar eliminar la notificacion: {ex.Message}" });
            }
        }
    }
}
