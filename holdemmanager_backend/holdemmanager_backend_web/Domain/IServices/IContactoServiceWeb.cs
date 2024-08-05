using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface IContactoServiceWeb
    {
        Task<PagedResult<Contacto>> GetAllContactos(int page, int pageSize);
        Task<Contacto> GetContactoById(int id);
        Task AddContacto(Contacto contacto);
        Task UpdateContacto(Contacto contacto);
        Task<bool> DeleteContacto(int id);
    }
}
