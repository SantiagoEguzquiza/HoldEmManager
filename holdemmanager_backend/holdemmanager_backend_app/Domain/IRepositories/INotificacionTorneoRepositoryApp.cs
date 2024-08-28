using holdemmanager_backend_app.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface INotificacionTorneoRepositoryApp
    {
        Task<NotificacionTorneo> GetNotificacionById(int id);
        Task AddNotificacion(int torneoId, NotificacionEnum tipoEvento);
        Task<bool> DeleteNotificacion(int id);
    }
}
