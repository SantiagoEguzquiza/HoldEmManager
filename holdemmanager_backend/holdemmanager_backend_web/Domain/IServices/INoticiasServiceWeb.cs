using holdemmanager_backend_app.Utils;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface INoticiasServiceWeb
    {
        Task<PagedResult<Noticia>> GetAllNoticias(int page, int pageSize);
        Task<Noticia> GetNoticiaById(int id);
        Task AddNoticia(Noticia noticia);
        Task UpdateNoticia(Noticia noticia);
        Task<bool> DeleteNoticia(int id);
    }
}
