using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_web.Domain.IServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Service
{
    public class NotificacionNoticiaServiceApp : INotificacionNoticiasWeb
    {
        private readonly INotificacionNoticiaRepositoryApp _notificacionRepositoryApp;
        public NotificacionNoticiaServiceApp(INotificacionNoticiaRepositoryApp notificacionRepositoryApp)
        {
            _notificacionRepositoryApp = notificacionRepositoryApp;
        }
        public async Task AddNotificacion(int noticiaId, string tipoEvento)
        {
            await _notificacionRepositoryApp.AddNotificacion(noticiaId, tipoEvento);
        }

        public async Task<bool> DeleteNotificacion(int id)
        {
            return await _notificacionRepositoryApp.DeleteNotificacion(id);
        }

        public async Task<NotificacionNoticia> GetNotificacionById(int id)
        {
            return await _notificacionRepositoryApp.GetNotificacionById(id);
        }
    }
}
