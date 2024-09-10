using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface INotificacionNoticiasWeb
    {
        Task AddNotificacion(int noticiaId, string tipoEvento);
        Task<bool> DeleteNotificacion(int id);
    }
}
