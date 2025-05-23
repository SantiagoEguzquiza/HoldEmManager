﻿using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_app.Utils;
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
    public class FeedbackAppController : ControllerBase
    {
        private readonly IFeedbackServiceApp _feedbackService;
        private readonly AplicationDbContextApp _dbContext;

        public FeedbackAppController(AplicationDbContextApp dbContext, IFeedbackServiceApp feedbackService)
        {
            _feedbackService = feedbackService;
            _dbContext = dbContext;
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet]
        public async Task<ActionResult<PagedResult<Feedback>>> GetAllFeedbacks(int page, int pageSize)
        {
            var devolucion = await _feedbackService.GetAllFeedbacks(page, pageSize);
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

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPost]
        public async Task<IActionResult> AddFeedback([FromBody] Feedback feedback)
        {
            try
            {
                if (feedback == null)
                {
                    return BadRequest(new { message = "El feedback no puede ser nulo." });
                }

                var usuarioExistente = await _dbContext.Jugadores
                    .Include(j => j.Feedbacks)
                    .FirstOrDefaultAsync(j => j.Id == feedback.IdUsuario);

                if (usuarioExistente == null)
                {
                    return BadRequest(new { message = "El usuario especificado no existe." });
                }

                if (!feedback.IsAnonimo)
                {
                    usuarioExistente.Feedbacks.Add(feedback);
                }
                else
                {
                    feedback.IdUsuario = null;
                }
                await _feedbackService.AddFeedback(feedback);

                return Ok(new { message = "Feedback agregado exitosamente." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Ocurrió un error al agregar el feedback.", details = ex.Message });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
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
