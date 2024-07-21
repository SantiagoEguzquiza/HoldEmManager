using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface INoticiasServiceWeb
    {
        Task<IEnumerable<Noticias>> GetAllNoticias();
        Task<Noticias> GetNoticiaById(int id);
        Task AddNoticia(Noticias noticia);
        Task UpdateNoticia(Noticias noticia);
        Task<bool> DeleteNoticia(int id);
    }
}
