using holdemmanager_backend_app.Utils;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IRepositories
{
    public interface INoticiasRepositoryWeb
    {
        Task<PagedResult<Noticia>> GetAllNoticias(int page, int pageSize, string filtro, string filtroFecha);
        Task<Noticia> GetNoticiaById(int id);
        Task AddNoticia(Noticia noticia);
        Task UpdateNoticia(Noticia noticia);
        Task<bool> DeleteNoticia(int id);
    }
}
