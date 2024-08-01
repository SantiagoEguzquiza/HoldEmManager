using holdemmanager_backend_app.Utils;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace holdemmanager_backend_web.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class RecursosEducativosWebController : ControllerBase
    {
        private readonly IRecursosEducativosServiceWeb _recursosEducativosService;
        private readonly AplicationDbContextWeb _dbContext;
        private readonly FirebaseStorageHelper _firebaseStorageHelper;

        public RecursosEducativosWebController(AplicationDbContextWeb dbContext, IRecursosEducativosServiceWeb recursosService, FirebaseStorageHelper firebaseStorageHelper)
        {
            _recursosEducativosService = recursosService;
            _dbContext = dbContext;
            _firebaseStorageHelper = firebaseStorageHelper;
        }

        // obtener todos los recursos educativos
        [HttpGet]
        public async Task<ActionResult<PagedResult<RecursoEducativo>>> GetAllRecursos(int page, int pageSize)
        {
            var recursos = await _recursosEducativosService.GetAllRecursos(page, pageSize);
            return Ok(recursos);
        }

        // obtener un recurso educativo con id como parametro
        [HttpGet("{id}")]
        public async Task<ActionResult<RecursoEducativo>> GetRecursoById(int id)
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
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] RecursoEducativo recurso)
        {
            try
            {
                if (recurso == null)
                {
                    return BadRequest(new { message = "El recurso no puede ser nulo." });
                }

                string? downloadUrl = null;

                if (recurso.URLImagen == "DELETE") {
                    recurso.URLImagen = null;
                }

                if (!recurso.URLImagen.IsNullOrEmpty())
                {
                    byte[] imagenBytes = Convert.FromBase64String(recurso.URLImagen);
                    var stream = new MemoryStream(imagenBytes);

                    downloadUrl = await _firebaseStorageHelper.SubirStorageRecurso(stream);
                }

                try
                {

                    RecursoEducativo recursoNuevo = new RecursoEducativo
                    {
                        Mensaje = recurso.Mensaje,
                        Titulo = recurso.Titulo,
                        URLImagen = downloadUrl,
                        URLVideo = recurso.URLVideo,
                    };
                    await _recursosEducativosService.AddRecurso(recursoNuevo);
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new { message = "Error al subir el archivo", details = ex.Message });
                }

                return Ok(new { message = "Recurso agregado exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // actualizar un recurso
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateRecurso(RecursoEducativo recurso)
        {
            if (recurso == null)
            {
                return BadRequest(new { message = "El recurso es nulo." });
            }

            try
            {
                string? newImageUrl = null;

                var recursoExistente = await _recursosEducativosService.GetRecursoById(recurso.Id);
                if (recursoExistente == null)
                {
                    return NotFound(new { message = "Recurso no encontrado" });
                }

                if (recurso.URLImagen == "UPDATE")
                {
                    newImageUrl = recursoExistente.URLImagen;
                }
                else if (recurso.URLImagen == "DELETE")
                {
                    if (!string.IsNullOrEmpty(recursoExistente.URLImagen))
                    {
                        await _firebaseStorageHelper.EliminarImagenRecurso(recursoExistente.URLImagen);
                    }
                    newImageUrl = null;
                }
                else if (!string.IsNullOrEmpty(recurso.URLImagen))
                {
                    byte[] imagenBytes = Convert.FromBase64String(recurso.URLImagen);
                    var stream = new MemoryStream(imagenBytes);

                    if (!string.IsNullOrEmpty(recursoExistente.URLImagen))
                    {
                        await _firebaseStorageHelper.EliminarImagenRecurso(recursoExistente.URLImagen);
                    }
                    newImageUrl = await _firebaseStorageHelper.SubirStorageRecurso(stream);
                }

                recursoExistente.Titulo = recurso.Titulo;
                recursoExistente.Mensaje = recurso.Mensaje;
                recursoExistente.URLVideo = recurso.URLVideo;
                recursoExistente.URLImagen = newImageUrl;

                await _recursosEducativosService.UpdateRecurso(recursoExistente);

                return Ok(new { message = "Recurso actualizado exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = "Error al actualizar el recurso", details = ex.Message });
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

                if (!string.IsNullOrEmpty(recurso.URLImagen))
                {
                    await _firebaseStorageHelper.EliminarImagenRecurso(recurso.URLImagen);
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
