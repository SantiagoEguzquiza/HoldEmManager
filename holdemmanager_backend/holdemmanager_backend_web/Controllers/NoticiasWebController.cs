using holdemmanager_backend_app.Utils;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Utils;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace holdemmanager_backend_web.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class NoticiasWebController : ControllerBase
    {
        private readonly INoticiasServiceWeb _noticiasService;
        private readonly AplicationDbContextWeb _dbContext;
        private readonly FirebaseStorageHelper _firebaseStorageHelper;

        public NoticiasWebController(AplicationDbContextWeb dbContext, INoticiasServiceWeb noticiasService, FirebaseStorageHelper firebaseStorageHelper)
        {
            _noticiasService = noticiasService;
            _dbContext = dbContext;
            _firebaseStorageHelper = firebaseStorageHelper;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<Noticia>>> GetAllNoticias(int page, int pageSize, string filtro, string? filtroFecha)
        {
            if (filtro == "NO")
            {
                filtro = "";
            }

            var noticias = await _noticiasService.GetAllNoticias(page, pageSize, filtro, filtroFecha!);
            return Ok(noticias);
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet("{id}")]
        public async Task<ActionResult<Noticia>> GetNoticiaById(int id)
        {
            try
            {
                var noticia = await _noticiasService.GetNoticiaById(id);

                if (noticia == null)
                {
                    return NotFound(new { message = "No se encontraron datos que coincidan con el id." });
                }

                return Ok(noticia);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontraron datos que coincidan con el id." });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPost]
        public async Task<IActionResult> AddNoticia([FromBody] Noticia noticiaHelper)
        {
            try
            {
                if (noticiaHelper == null)
                {
                    return BadRequest(new { message = "La noticia no puede ser nula." });
                }
                string? downloadUrl = null;

                if (noticiaHelper.IdImagen == "DELETE")
                {
                    noticiaHelper.IdImagen = null;
                }

                if (!noticiaHelper.IdImagen.IsNullOrEmpty())
                {
                    byte[] imagenBytes = Convert.FromBase64String(noticiaHelper.IdImagen);
                    var stream = new MemoryStream(imagenBytes);

                    downloadUrl = await _firebaseStorageHelper.SubirStorageNoticia(stream);
                }

                try
                {

                    Noticia noticia = new Noticia
                    {
                        Fecha = noticiaHelper.Fecha,
                        Mensaje = noticiaHelper.Mensaje,
                        Titulo = noticiaHelper.Titulo,
                        IdImagen = downloadUrl
                    };
                    await _noticiasService.AddNoticia(noticia);
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new { message = "Error al subir el archivo", details = ex.Message });
                }

                return Ok(new { message = "Noticia agregada exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateNoticia(int id, Noticia noticiaHelper)
        {
            if (noticiaHelper == null || id != noticiaHelper.Id)
            {
                return BadRequest(new { message = "ID de la noticia no coincide o la noticia es nula." });
            }

            try
            {
                string? newImageUrl = null;

                var noticiaExistente = await _noticiasService.GetNoticiaById(id);
                if (noticiaExistente == null)
                {
                    return NotFound(new { message = "Noticia no encontrada" });
                }

                if (noticiaHelper.IdImagen == "UPDATE")
                {
                    newImageUrl = noticiaExistente.IdImagen;
                }
                else if (noticiaHelper.IdImagen == "DELETE")
                {
                    if (!string.IsNullOrEmpty(noticiaExistente.IdImagen))
                    {
                        await _firebaseStorageHelper.EliminarImagenNoticia(noticiaExistente.IdImagen);
                    }
                    newImageUrl = null;
                }
                else if (!string.IsNullOrEmpty(noticiaHelper.IdImagen))
                {
                    byte[] imagenBytes = Convert.FromBase64String(noticiaHelper.IdImagen);
                    var stream = new MemoryStream(imagenBytes);

                    if (!string.IsNullOrEmpty(noticiaExistente.IdImagen))
                    {
                        await _firebaseStorageHelper.EliminarImagenNoticia(noticiaExistente.IdImagen);
                    }
                    newImageUrl = await _firebaseStorageHelper.SubirStorageNoticia(stream);
                }

                noticiaExistente.Fecha = noticiaHelper.Fecha;
                noticiaExistente.Mensaje = noticiaHelper.Mensaje;
                noticiaExistente.Titulo = noticiaHelper.Titulo;
                noticiaExistente.IdImagen = newImageUrl;

                await _noticiasService.UpdateNoticia(noticiaExistente);
                return Ok(new { message = "Noticia actualizada exitosamente." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error al actualizar la noticia", details = ex.Message });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
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

                if (!string.IsNullOrEmpty(noticia.IdImagen))
                {
                    await _firebaseStorageHelper.EliminarImagenNoticia(noticia.IdImagen);
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
