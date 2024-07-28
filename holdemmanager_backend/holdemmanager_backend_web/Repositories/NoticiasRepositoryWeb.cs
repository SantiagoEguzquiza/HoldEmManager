using holdemmanager_backend_app.Utils;
using holdemmanager_backend_web.Domain.Excepciones;
using holdemmanager_backend_web.Domain.IRepositories;
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
        public NoticiasRepositoryWeb(AplicationDbContextWeb context)
        {
            this._context = context;
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
            _context.Noticias.Add(noticia);
            await _context.SaveChangesAsync();
        }


        public async Task<bool> DeleteNoticia(int id)
        {
            var noticia = await _context.Noticias.Where(x => x.Id == id).FirstOrDefaultAsync();

            if (noticia != null)
            {
                _context.Noticias.Remove(noticia);
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }


        public async Task UpdateNoticia(Noticia noticia)
        {
            _context.Noticias.Update(noticia);
            await _context.SaveChangesAsync();
        }

        public async Task<PagedResult<Noticia>> GetAllNoticias(int page, int pageSize)
        {
            var noticias = await _context.Noticias
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
