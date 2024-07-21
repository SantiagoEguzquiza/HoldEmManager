using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class FeedbackAppController : ControllerBase
    {
        private readonly IFeedbackServiceApp _feedbackService;
        private readonly AplicationDbContextApp _dbContext;

        public FeedbackAppController(AplicationDbContextApp dbContext, IFeedbackServiceApp feedbackService)
        {
            _feedbackService = feedbackService;
            _dbContext = dbContext;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Feedback>>> GetAllFeedbacks()
        {
            var devolucion = await _feedbackService.GetAllFeedbacks();
            return Ok(devolucion);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Feedback>> GetFeedbackById(int id)
        {
            try
            {
                var devolucion = await _feedbackService.GetFeedbackById(id);
                return Ok(devolucion);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontraron datos que coincidan con el id." });
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddFeedback([FromBody] Feedback devolucion)
        {
            try
            {
                if (devolucion == null)
                {
                    return BadRequest(new { message = "El feedback no puede ser nulo." });
                }

                await _feedbackService.AddFeedback(devolucion);

                return Ok(new { message = "Feedback agregado exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateFeedback(int id, Feedback devolucion)
        {
            if (devolucion == null || id != devolucion.Id)
            {
                return BadRequest(new { message = "ID del feedback no coincide o el feedback es nulo." });
            }

            try
            {
                await _feedbackService.UpdateFeedback(devolucion);
                return Ok(new { message = "Feedback actualizado exitosamente." });
            }
            catch (Exception)
            {
                return BadRequest(new { message = "Feedback no encontrado" });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFeedback(int id)
        {
            try
            {
                var devolucion = await _feedbackService.GetFeedbackById(id);
                if (devolucion == null)
                {
                    return BadRequest(new { message = "El feedback no existe." });
                }

                var deleteResult = await _feedbackService.DeleteFeedback(id);
                if (deleteResult)
                {
                    return Ok(new { message = "Feedback eliminado exitosamente." });
                }
                else
                {
                    return BadRequest(new { message = "No se pudo eliminar el feedback." });
                }
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Ocurrió un error al intentar eliminar el feedback: {ex.Message}" });
            }
        }
    }
}
