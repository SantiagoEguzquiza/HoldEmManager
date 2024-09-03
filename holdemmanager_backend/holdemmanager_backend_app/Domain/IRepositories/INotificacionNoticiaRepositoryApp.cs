using holdemmanager_backend_app.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface INotificacionNoticiaRepositoryApp
    {
        Task<NotificacionNoticia> GetNotificacionById(int id);
        Task AddNotificacion(int noticiaId, string tipoEvento);
        Task<bool> DeleteNotificacion(int id);
    }
}
