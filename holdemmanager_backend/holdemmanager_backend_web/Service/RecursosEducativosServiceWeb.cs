using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Service
{
    public class RecursosEducativosServiceWeb : IRecursosEducativosServiceWeb
    {
        private readonly IRecursosEducativosRepositoryWeb _recursosRepository;

        public RecursosEducativosServiceWeb(IRecursosEducativosRepositoryWeb recursosRepository)
        {

            _recursosRepository = recursosRepository;
        }

        public async Task<PagedResult<RecursoEducativo>> GetAllRecursos(int page, int pageSize, string filtro)
        {
            return await _recursosRepository.GetAllRecursos(page, pageSize, filtro);
        }

        public async Task<RecursoEducativo> GetRecursoById(int id)
        {
            return await _recursosRepository.GetRecursoById(id);
        }

        public async Task AddRecurso(RecursoEducativo recurso)
        {
            await _recursosRepository.AddRecurso(recurso);
        }

        public async Task UpdateRecurso(RecursoEducativo recurso)
        {
            await _recursosRepository.UpdateRecurso(recurso);
        }

        public async Task<bool> DeleteRecurso(int id)
        {
            return await _recursosRepository.DeleteRecurso(id);
        }
    }
}
