using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_web.Migrations;
using holdemmanager_backend_web.Persistence;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Repositories
{
    public class NotificacionTorneoRepositoryApp : INotificacionTorneoRepositoryApp
    {
        private readonly AplicationDbContextApp _contextApp;
        private readonly AplicationDbContextWeb _contextWeb;
        public NotificacionTorneoRepositoryApp(AplicationDbContextApp contextApp, AplicationDbContextWeb contextWeb)
        {
            _contextApp = contextApp;
            _contextWeb = contextWeb;
        }

        public async Task AddNotificacion(int torneoId, string tipoEvento)
        {
            try
            {
                var torneo = await _contextWeb.Torneos.FindAsync(torneoId);             

                var evento = tipoEvento == "ELIMINADO" ? NotificacionTorneoEnum.ELIMINADO : NotificacionTorneoEnum.EDITADO;

                var usuariosFavoritos = await _contextApp.Favoritos
                    .Where(f => f.TorneoId == torneoId)
                    .Select(f => f.JugadorId)
                    .ToListAsync();

                if (!usuariosFavoritos.Any())
                {
                    return;
                }

                foreach (var usuarioId in usuariosFavoritos)
                {
                    var jugador = await _contextApp.Jugadores.FindAsync(usuarioId);
                    if (jugador == null)
                    {
                        throw new Exception($"Jugador con ID {usuarioId} no encontrado.");
                    }

                    var notificacion = new NotificacionTorneo
                    {
                        TorneoId = torneo.Id,
                        JugadorId = jugador.Id,
                        TipoEvento = evento,
                        Fecha = DateTime.Now,
                        Mensaje = $"El torneo {torneo.Nombre} ha sido {tipoEvento}."
                    };

                    _contextApp.NotificacionTorneos.Add(notificacion);
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
            var notificacion = await _contextApp.NotificacionTorneos.Where(n => n.Id == id).FirstOrDefaultAsync();

            if (notificacion != null)
            {
                _contextApp.NotificacionTorneos.Remove(notificacion);
                await _contextApp.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public async Task<NotificacionTorneo> GetNotificacionById(int id)
        {
            var notificacion = await _contextApp.NotificacionTorneos.Where(c => c.Id == id).FirstOrDefaultAsync();
            if (notificacion == null)
            {
                throw new Exception($"La notificacion con id {id} no fue encontrada o no existe");
            }

            return notificacion;
        }
    }
}
