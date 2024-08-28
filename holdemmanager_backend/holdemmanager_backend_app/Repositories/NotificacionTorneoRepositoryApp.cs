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
    public class NotificacionTorneoRepositoryApp : INotificacionTorneoRepositoryApp
    {
        private readonly AplicationDbContextApp _context;
        private readonly AplicationDbContextWeb _contextWeb;
        public NotificacionTorneoRepositoryApp(AplicationDbContextApp context, AplicationDbContextWeb contextWeb)
        {
            this._context = context;
            this._contextWeb = contextWeb;
        }
        public async Task AddNotificacion(NotificacionTorneo notificacion)
        {
            _context.Add(notificacion);
            await _context.SaveChangesAsync();
        }

        public async Task AddNotificacion(int torneoId, NotificacionEnum tipoEvento)
        {
            var torneo = await _contextWeb.Torneos.FindAsync(torneoId);

            if (torneo == null)
            {
                throw new Exception("Torneo no encontrado");
            }

            var usuariosFavoritos = await _context.Favoritos
                .Where(f => f.TorneoId == torneoId)
                .Select(f => f.JugadorId)
                .ToListAsync();

            if (!usuariosFavoritos.Any())
            {
                return; 
            }

            var notificaciones = usuariosFavoritos.Select(usuarioId => new NotificacionTorneo
            {
                TorneoId = torneoId,
                JugadorId = usuarioId,
                TipoEvento = tipoEvento,
                Fecha = DateTime.Now,
                Mensaje = $"El torneo {torneo.Nombre} ha sido {tipoEvento}."
            }).ToList();

            await _context.NotificacionTorneos.AddRangeAsync(notificaciones);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteNotificacion(int id)
        {
            var notificacion = await _context.NotificacionTorneos.Where(n => n.Id == id).FirstOrDefaultAsync();

            if (notificacion != null)
            {
                _context.NotificacionTorneos.Remove(notificacion);
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public async Task<NotificacionTorneo> GetNotificacionById(int id)
        {
            var notificacion = await _context.NotificacionTorneos.Where(c => c.Id == id).FirstOrDefaultAsync();
            if (notificacion == null)
            {
                throw new Exception($"La notificacion con id {id} no fue encontrada o no existe");
            }

            return notificacion;
        }
    }
}
