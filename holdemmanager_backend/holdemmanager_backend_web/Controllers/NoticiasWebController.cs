using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class NoticiasWebController : ControllerBase
    {
        private readonly INoticiasServiceWeb _noticiasService;
        private readonly AplicationDbContextWeb _dbContext;

        public NoticiasWebController(AplicationDbContextWeb dbContext, INoticiasServiceWeb noticiasService)
        {
            _noticiasService = noticiasService;
            _dbContext = dbContext;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Noticias>>> GetAllNoticias()
        {
            var recursos = await _noticiasService.GetAllNoticias();
            return Ok(recursos);
        }


        [HttpGet("{id}")]
        public async Task<ActionResult<Noticias>> GetNoticiaById(int id)
        {
            try
            {
                var recurso = await _noticiasService.GetNoticiaById(id);
                return Ok(recurso);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontraron datos que coincidan con el id." });
            }
        }


        [HttpPost]
        public async Task<IActionResult> AddNoticia([FromBody] Noticias noticia)
        {
            try
            {
                if (noticia == null)
                {
                    return BadRequest(new { message = "La noticia no puede ser nula." });
                }

                await _noticiasService.AddNoticia(noticia);

                return Ok(new { message = "Noticia agregada exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateNoticia(int id, Noticias noticia)
        {
            if (noticia == null || id != noticia.Id)
            {
                return BadRequest(new { message = "ID de la noticia no coincide o la noticia es nula." });
            }

            try
            {
                await _noticiasService.UpdateNoticia(noticia);
                return Ok(new { message = "Noticia agregada exitosamente." });
            }
            catch (Exception)
            {
                return BadRequest(new { message = "Noticia no encontrada" });
            }
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteNoticia(int id)
        {
            try
            {
                var noticia = await _noticiasService.GetNoticiaById(id);
                if (noticia == null)
                {
                    return BadRequest(new { message = "La noticia no existe." });
                }

                var deleteResult = await _noticiasService.DeleteNoticia(id);
                if (deleteResult)
                {
                    return Ok(new { message = "Noticia eliminada exitosamente." });
                }
                else
                {
                    return BadRequest(new { message = "No se pudo eliminar la noticia." });
                }
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Ocurrió un error al intentar eliminar la noticia: {ex.Message}" });
            }
        }
    }
}
