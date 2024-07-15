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
using System.Numerics;
using System.Security.Claims;

namespace holdemmanager_backend_app.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class MapaAppController : ControllerBase
    {
        private readonly IMapaServiceApp _mapaService;
        private readonly AplicationDbContextApp _dbContext;
        public MapaAppController(AplicationDbContextApp dbContext, IMapaServiceApp mapaService)
        {

            _mapaService = mapaService;
            _dbContext = dbContext;
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] MapaHelper mapa)
        {
            try
            {
                if (mapa == null)
                {
                    return BadRequest(new { message = "Ocurrió un error al guardar el plano" });
                }

                byte[] planoBytes;
                Mapa plano;
                try
                {
                    planoBytes = Convert.FromBase64String(mapa.PlanoString);
                    plano = new Mapa();
                    plano.Plano = planoBytes;
                    plano.PlanoId = mapa.PlanoId;
                }
                catch (FormatException)
                {
                    return BadRequest(new { message = "Error al guardar el plano." });
                }



                await _mapaService.SavePlano(plano);

                return Ok(new { message = "Plano guardado con éxito" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Ocurrió un error al guardar el plano", details = ex.Message });
            }
        }

        [HttpGet]
        public async Task<ActionResult<Mapa>> GetMapa()
        {
            try
            {
                List<Mapa> mapa = await _mapaService.GetMapa();

                return Ok(mapa);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontro el mapa." });
            }
        }
    }
}
