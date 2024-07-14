using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Service
{
    public class NoticiasServiceWeb : INoticiasServiceWeb
    {
        private readonly INoticiasRepositoryWeb _noticiasRepository;

        public NoticiasServiceWeb(INoticiasRepositoryWeb noticiasRepository)
        {
           _noticiasRepository = noticiasRepository;            
        }

        public async Task AddNoticia(Noticias noticia)
        {
            await _noticiasRepository.UpdateNoticia(noticia);
        }

        public async Task<bool> DeleteNoticia(int id)
        {
            return await _noticiasRepository.DeleteNoticia(id);
        }

        public async Task<IEnumerable<Noticias>> GetAllNoticias()
        {
            return await _noticiasRepository.GetAllNoticias();
        }

        public async Task<Noticias> GetNoticiaById(int id)
        {
            return await _noticiasRepository.GetNoticiaById(id);
        }

        public async Task UpdateNoticia(Noticias noticia)
        {
            await _noticiasRepository.UpdateNoticia(noticia);
        }
    }
}
