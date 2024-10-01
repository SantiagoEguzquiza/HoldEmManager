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
    public class ContactoWebController : ControllerBase
    {
        private readonly IContactoServiceWeb _contactosService;
        private readonly AplicationDbContextWeb _dbContext;

        public ContactoWebController(IContactoServiceWeb contactosService)
        {
            _contactosService = contactosService;
        }

        // obtener todos los contactos
        [HttpGet]
        public async Task<ActionResult<PagedResult<Contacto>>> GetAllContactos(int page, int pageSize)
        {
            var contactos = await _contactosService.GetAllContactos(page, pageSize);
            return Ok(contactos);
        }


        // obtener un contacto con id como parametro
        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet("{id}")]
        public async Task<ActionResult<Contacto>> GetContactoById(int id)
        {
            try
            {
                var contacto = await _contactosService.GetContactoById(id);
                return Ok(contacto);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontraron datos que coincidan con el id." });
            }
        }


        // agregar un contacto
        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPost]
        public async Task<IActionResult> AddContacto([FromBody] Contacto contacto)
        {
            try
            {
                if (contacto == null)
                {
                    return BadRequest(new { message = "El contacto no puede ser nulo." });
                }

                await _contactosService.AddContacto(contacto);

                return Ok(new { message = "Contacto agregado exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        // actualizar un contacto
        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateRecurso(int id, Contacto contacto)
        {
            if (contacto == null || id != contacto.Id)
            {
                return BadRequest(new { message = "ID del contacto no coincide o el contacto es nulo." });
            }

            try
            {
                await _contactosService.UpdateContacto(contacto);
                return Ok(new { message = "Contacto agregado exitosamente." });
            }
            catch (Exception)
            {
                return BadRequest(new { message = "Contacto no encontrado" });
            }
        }


        // borrar un contacto
        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRecurso(int id)
        {
            try
            {
                var contacto = await _contactosService.GetContactoById(id);
                if (contacto == null)
                {
                    return BadRequest(new { message = "El contacto no existe." });
                }

                var deleteResult = await _contactosService.DeleteContacto(id);
                if (deleteResult)
                {
                    return Ok(new { message = "Contacto eliminado exitosamente." });
                }
                else
                {
                    return BadRequest(new { message = "No se pudo eliminar el contacto." });
                }
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Ocurrió un error al intentar eliminar el contacto: {ex.Message}" });
            }
        }
    }
}
