using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IRepositories
{
    public interface IRecursosEducativosRepositoryWeb
    {
        Task<PagedResult<RecursoEducativo>> GetAllRecursos(int page, int pageSize);
        Task<RecursoEducativo> GetRecursoById(int id);
        Task AddRecurso(RecursoEducativo recurso);
        Task UpdateRecurso(RecursoEducativo recurso);
        Task<bool> DeleteRecurso(int id);
    }
}
