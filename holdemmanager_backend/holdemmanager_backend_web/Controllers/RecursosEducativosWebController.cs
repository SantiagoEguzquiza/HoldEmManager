using holdemmanager_backend_web.Domain.Excepciones;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class RecursosEducativosWebController : ControllerBase
    {
        private readonly IRecursosEducativosServiceWeb _recursosEducativosService;
        private readonly AplicationDbContextWeb _dbContext;

        public RecursosEducativosWebController(AplicationDbContextWeb dbContext, IRecursosEducativosServiceWeb recursosService)
        {
            _recursosEducativosService = recursosService;
            _dbContext = dbContext;
        }

        // obtener todos los recursos educativos
        [HttpGet]
        public async Task<ActionResult<IEnumerable<RecursosEducativos>>> GetAllRecursos()
        {
            var recursos = await _recursosEducativosService.GetAllRecursos();
            return Ok(recursos);
        }

        // obtener un recurso educativo con id como parametro
        [HttpGet("{id}")]
        public async Task<ActionResult<RecursosEducativos>> GetRecursoById(int id)
        {
            try
            {
                var recurso = await _recursosEducativosService.GetRecursoById(id);
                return Ok(recurso);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontraron datos que coincidan con el id." });
            }
        }

        // agregar un recurso
        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPost]
        public async Task<IActionResult> AddRecurso([FromBody] RecursosEducativos recurso)
        {
            try
            {
                if (recurso == null)
                {
                    return BadRequest(new { message = "El recurso no puede ser nulo." });
                }

                await _recursosEducativosService.AddRecurso(recurso);

                return Ok(new { message = "Recurso agregado exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // actualizar un recurso
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateRecurso(int id, RecursosEducativos recurso)
        {
            if (recurso == null || id != recurso.Id)
            {
                return BadRequest(new { message = "ID del recurso no coincide o el recurso es nulo." });
            }

            try
            {
                await _recursosEducativosService.UpdateRecurso(recurso);
                return Ok(new { message = "Recurso agregado exitosamente." });
            }
            catch (Exception)
            {
                return BadRequest(new { message = "Recurso no encontrado" });
            }
        }

        // borrar un recurso
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRecurso(int id)
        {
            try
            {
                var recurso = await _recursosEducativosService.GetRecursoById(id);
                if (recurso == null)
                {
                    return BadRequest(new { message = "El recurso no existe." });
                }

                var deleteResult = await _recursosEducativosService.DeleteRecurso(id);
                if (deleteResult)
                {
                    return Ok(new { message = "Recurso eliminado exitosamente." });
                }
                else
                {
                    return BadRequest(new { message = "No se pudo eliminar el recurso." });
                }
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Ocurrió un error al intentar eliminar el recurso: {ex.Message}" });
            }
        }
    }
}
