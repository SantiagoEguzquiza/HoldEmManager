using holdemmanager_backend_app.Utils;
using holdemmanager_backend_web.Domain.Excepciones;
using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Repositories
{
    public class NoticiasRepositoryWeb : INoticiasRepositoryWeb
    {
        private readonly AplicationDbContextWeb _context;
        private readonly INotificacionNoticiasWeb _notificacionService;
        public NoticiasRepositoryWeb(AplicationDbContextWeb context, INotificacionNoticiasWeb notificacionService)
        {
            this._context = context;
            this._notificacionService = notificacionService;
        }

        public async Task<Noticia> GetNoticiaById(int id)
        {
            var noticia = await _context.Noticias.Where(x => x.Id == id).FirstOrDefaultAsync();
            if (noticia == null)
            {
                throw new Exception($"La noticia con ID {id} no fue encontrada o no existe.");
            }

            return noticia;
        }


        public async Task AddNoticia(Noticia noticia)
        {
            try
            {
                _context.Noticias.Add(noticia);
                await _context.SaveChangesAsync();

                await _notificacionService.AddNotificacion(noticia.Id, "AGREGADA");
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al agregar noticia: {ex.Message}");
                throw;
            }

        }


        public async Task<bool> DeleteNoticia(int id)
        {
            var noticia = await _context.Noticias.Where(x => x.Id == id).FirstOrDefaultAsync();

            if (noticia != null)
            {
                try
                {
                    _context.Noticias.Remove(noticia);
                    await _notificacionService.AddNotificacion(id, "ELIMINADA");
                    await _context.SaveChangesAsync();
                    return true;
                }
                catch (Exception ex)
                {
                    throw new Exception($"Error al eliminar noticia: {ex.Message}");
                    throw;
                }
            }
            return false;
        }


        public async Task UpdateNoticia(Noticia noticia)
        {
            try
            {
                _context.Noticias.Update(noticia);
                await _context.SaveChangesAsync();
                await _notificacionService.AddNotificacion(noticia.Id, "EDITADA");
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al editar noticia: {ex.Message}");
                throw;
            }

        }

        public async Task<PagedResult<Noticia>> GetAllNoticias(int page, int pageSize, string filtro, string filtroFecha)
        {
            var query = _context.Noticias.AsQueryable();

            if (!string.IsNullOrWhiteSpace(filtro))
            {
                query = query.Where(r => r.Titulo.Contains(filtro) || r.Mensaje.Contains(filtro));
            }

            if (!string.IsNullOrEmpty(filtroFecha) && filtroFecha != "null")
            {
                if (DateTime.TryParse(filtroFecha, out DateTime fechaParsed))
                {
                    query = query.Where(r => r.Fecha.Date == fechaParsed.Date);
                }
            }

            var totalItems = await query.CountAsync();

            var noticias = await query
                                 .Skip((page - 1) * pageSize)
                                 .Take(pageSize + 1)
                                 .ToListAsync();

            var hasNextPage = noticias.Count > pageSize;

            if (hasNextPage)
            {
                noticias.RemoveAt(pageSize);
            }

            return new PagedResult<Noticia>
            {
                Items = noticias,
                HasNextPage = hasNextPage
            };
        }
    }
}
