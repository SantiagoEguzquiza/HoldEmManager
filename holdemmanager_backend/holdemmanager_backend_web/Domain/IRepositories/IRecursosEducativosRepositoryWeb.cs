using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IRepositories
{
    public interface IRecursosEducativosRepositoryWeb
    {
        Task<IEnumerable<RecursosEducativos>> GetAllRecursos();
        Task<RecursosEducativos> GetRecursoById(int id);
        Task AddRecurso(RecursosEducativos recurso);
        Task UpdateRecurso(RecursosEducativos recurso);
        Task<bool> DeleteRecurso(int id);
    }
}
