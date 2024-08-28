using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
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
    public class NotificacionTorneoAppController : ControllerBase
    {
        private readonly INotificacionTorneoServiceApp _notificacionService;
        private readonly AplicationDbContextApp _dbContext;

        public NotificacionTorneoAppController(AplicationDbContextApp dbContext, INotificacionTorneoServiceApp notificacionService)
        {
            _notificacionService = notificacionService;
            _dbContext = dbContext;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<NotificacionTorneo>> GetNotificacionById(int id)
        {
            try
            {
                var notificacion = await _notificacionService.GetNotificacionById(id);
                if (notificacion == null)
                {
                    return NotFound("Notificación no encontrada.");
                }
                return Ok(notificacion);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontraron datos que coincidan con el id." });
            }
        }


        [HttpPost]
        public async Task<IActionResult> AddNotificacion(int torneoId, NotificacionEnum tipoEvento)
        {
            try
            {
                await _notificacionService.AddNotificacion(torneoId, tipoEvento);
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
                var notificacion = await _notificacionService.GetNotificacionById(id);
                if (notificacion == null)
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
