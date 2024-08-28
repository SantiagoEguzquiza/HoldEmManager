using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Service
{
    public class NotificacionTorneoServiceApp : INotificacionTorneoServiceApp
    {
        private readonly INotificacionTorneoRepositoryApp _notificacionRepositoryApp;
        public NotificacionTorneoServiceApp(INotificacionTorneoRepositoryApp notificacionRepository)
        {
            this._notificacionRepositoryApp = notificacionRepository;
        }

        public async Task AddNotificacion(int torneoId, NotificacionEnum tipoEvento)
        {
            await _notificacionRepositoryApp.AddNotificacion(torneoId, tipoEvento);
        }

        public async Task<bool> DeleteNotificacion(int id)
        {
            return await _notificacionRepositoryApp.DeleteNotificacion(id);
        }

        public async Task<NotificacionTorneo> GetNotificacionById(int id)
        {
            return await _notificacionRepositoryApp.GetNotificacionById(id);
        }
    }
}
