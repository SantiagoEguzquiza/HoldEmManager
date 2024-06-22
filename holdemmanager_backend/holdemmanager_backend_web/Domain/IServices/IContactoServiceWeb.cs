using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface IContactoServiceWeb
    {
        Task<IEnumerable<Contacto>> GetAllContactos();
        Task<Contacto> GetContactoById(int id);
        Task AddContacto(Contacto contacto);
        Task UpdateContacto(Contacto contacto);
        Task<bool> DeleteContacto(int id);
    }
}
