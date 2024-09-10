using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Utils;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace holdemmanager_backend_web.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class TorneosWebController : ControllerBase
    {
        private readonly ITorneosServiceWeb _torneosService;
        private readonly AplicationDbContextWeb _dbContext;

        public TorneosWebController(ITorneosServiceWeb torneosService, AplicationDbContextWeb dbContext)
        {
            _torneosService = torneosService;
            _dbContext = dbContext;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<Torneos>>> GetAllTorneos(int page, int pageSize, string? filtro, string? filtroFecha)
        {
            if (filtro == "NO" || filtro == null)
            {
                filtro = "";
            }

            var torneos = await _torneosService.GetAllTorneos(page, pageSize, filtro!, filtroFecha!);
            return Ok(torneos);
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet("{id}")]
        public async Task<ActionResult<Torneos>> GetTorneoById(int id)
        {
            try
            {
                var torneo = await _torneosService.GetTorneoById(id);
                return Ok(torneo);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontraron datos que coincidan con el id." });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPost]
        public async Task<IActionResult> AddTorneo([FromBody] Torneos torneo)
        {
            try
            {
                if (torneo == null)
                {
                    return BadRequest(new { message = "El torneo no puede ser nulo." });
                }

                await _torneosService.AddTorneo(torneo);

                return Ok(new { message = "Torneo agregado exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateTorneo(int id, Torneos torneo)
        {
            if (torneo == null || id != torneo.Id)
            {
                return BadRequest(new { message = "ID del torneo no coincide o el torneo es nulo." });
            }

            try
            {
                await _torneosService.UpdateTorneo(torneo);
                return Ok(new { message = "Torneo agregado exitosamente." });
            }
            catch (Exception)
            {
                return BadRequest(new { message = "Torneo no encontrado" });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTorneo(int id)
        {
            try
            {
                var torneo = await _torneosService.GetTorneoById(id);
                if (torneo == null)
                {
                    return BadRequest(new { message = "El torneo no existe." });
                }

                var deleteResult = await _torneosService.DeleteTorneo(id);
                if (deleteResult)
                {
                    return Ok(new { message = "Torneo eliminado exitosamente." });
                }
                else
                {
                    return BadRequest(new { message = "No se pudo eliminar el torneo." });
                }
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Ocurrió un error al intentar eliminar el torneo: {ex.Message}" });
            }
        }
    }
}
