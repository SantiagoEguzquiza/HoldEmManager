using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;

namespace holdemmanager_backend_web.Service
{
    public class NoticiasServiceWeb : INoticiasServiceWeb
    {
        private readonly INoticiasRepositoryWeb _noticiasRepository;

        public NoticiasServiceWeb(INoticiasRepositoryWeb noticiasRepository)
        {
            _noticiasRepository = noticiasRepository;
        }

        public async Task AddNoticia(Noticia noticia)
        {
            await _noticiasRepository.AddNoticia(noticia);
        }


        public async Task<bool> DeleteNoticia(int id)
        {
            return await _noticiasRepository.DeleteNoticia(id);
        }

        public async Task<PagedResult<Noticia>> GetAllNoticias(int page, int pageSize, string filtro)
        {
            return await _noticiasRepository.GetAllNoticias(page, pageSize, filtro);
        }

        public async Task<Noticia> GetNoticiaById(int id)
        {
            return await _noticiasRepository.GetNoticiaById(id);
        }

        public async Task UpdateNoticia(Noticia noticia)
        {
            await _noticiasRepository.UpdateNoticia(noticia);
        }
    }
}
