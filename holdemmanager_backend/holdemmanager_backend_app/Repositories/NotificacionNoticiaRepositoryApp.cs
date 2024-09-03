using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_web.Persistence;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Repositories
{
    public class NotificacionNoticiaRepositoryApp : INotificacionNoticiaRepositoryApp
    {
        private readonly AplicationDbContextApp _contextApp;
        private readonly AplicationDbContextWeb _contextWeb;
        public NotificacionNoticiaRepositoryApp(AplicationDbContextApp contextApp, AplicationDbContextWeb contextWeb)
        {
            _contextApp = contextApp;
            _contextWeb = contextWeb;
        }
        public async Task AddNotificacion(int noticiaId, string tipoEvento)
        {
            try
            {
                var noticia = await _contextWeb.Noticias.FindAsync(noticiaId);

                if (noticia == null)
                {
                    throw new Exception("Noticia no encontrada");
                }

                var evento = tipoEvento == "AGREGADA" ? NotificacionNoticiaEnum.AGREGADA : tipoEvento == "EDITADA" ? NotificacionNoticiaEnum.EDITADA : NotificacionNoticiaEnum.ELIMINADA;

                var usuarios = await _contextApp.Jugadores
                    .Where(j => j.NoticiasNotifications == true)
                    .ToListAsync();

                if (!usuarios.Any())
                {
                    return;
                }

                foreach (var u in usuarios)
                {
                    var notificacion = new NotificacionNoticia
                    {
                        JugadorId = u.Id,
                        TipoEvento = evento,
                        Fecha = DateTime.Now,
                        Mensaje = $"La noticia {noticia.Titulo} ha sido {tipoEvento}"
                    };

                    _contextApp.NotificacionNoticias.Add(notificacion);
                }

                await _contextApp.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al agregar notificaciones: {ex.Message}");
                throw;
            }
        }

        public async Task<bool> DeleteNotificacion(int id)
        {
            var notificacion = await _contextApp.NotificacionNoticias.Where(n => n.Id == id).FirstOrDefaultAsync();

            if (notificacion != null)
            {
                _contextApp.NotificacionNoticias.Remove(notificacion);
                await _contextApp.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public async Task<NotificacionNoticia> GetNotificacionById(int id)
        {
            var notificacion = await _contextApp.NotificacionNoticias.Where(c => c.Id == id).FirstOrDefaultAsync();
            if (notificacion == null)
            {
                throw new Exception($"La notificacion con id {id} no fue encontrada o no existe");
            }

            return notificacion;
        }
    }
}
