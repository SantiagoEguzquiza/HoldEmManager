using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface INotificacionServiceWeb
    {
        Task AddNotificacion(int torneoId, string tipoEvento);
        Task<bool> DeleteNotificacion(int id);
    }
}
