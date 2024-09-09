using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_web.Persistence;
using Microsoft.AspNetCore.Http;
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
    public class FavoritoAppController : ControllerBase
    {
        private readonly IFavoritoServiceApp _favoritosService;
        private readonly AplicationDbContextApp _dbContext;
        private readonly AplicationDbContextWeb _dbContextWeb;

        public FavoritoAppController(AplicationDbContextApp context, IFavoritoServiceApp favoritoService, AplicationDbContextWeb contextWeb)
        {
            _favoritosService = favoritoService;
            _dbContext = context;
            _dbContextWeb = contextWeb;
        }

        [HttpGet("{jugadorId}")]
        public async Task<ActionResult> ObtenerFavoritos(int jugadorId)
        {
            var torneosFavoritosIds = await _favoritosService.GetTorneosFavoritos(jugadorId);
            var torneosFavoritos = await _dbContextWeb.Torneos.Where(t => torneosFavoritosIds.Contains(t.Id)).ToListAsync();
            return Ok(torneosFavoritos);
        }


        [HttpPost("{jugadorId}/{torneoId}")]
        public async Task<ActionResult> AgregarFavorito(int jugadorId, int torneoId)
        {
            try
            {
                await _favoritosService.AddTorneoFavorito(jugadorId, torneoId);
                return Ok();
            }
            catch (Exception)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "No se pudo agregar el torneo a favoritos." });
            }          
        }
 

        [HttpDelete("{jugadorId}/{torneoId}")]
        public async Task<ActionResult> EliminarFavorito(int jugadorId, int torneoId)
        {
            try
            {
                bool devolucion = await _favoritosService.EliminarTorneoFavorito(jugadorId, torneoId);
                if (devolucion)
                {
                    return Ok(new { message = "Torneo eliminado de favoritos con éxito." });
                }
                return NotFound(new { message = "Torneo no encontrado en favoritos." });

            }
            catch (Exception)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "Error al eliminar el torneo de favoritos." });
            }
           
        }
    }
}
