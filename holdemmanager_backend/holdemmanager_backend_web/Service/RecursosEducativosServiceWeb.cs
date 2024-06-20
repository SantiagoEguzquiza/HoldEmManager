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
    public class RecursosEducativosServiceWeb : IRecursosEducativosServiceWeb
    {
        private readonly IRecursosEducativosRepositoryWeb _recursosRepository;

        public RecursosEducativosServiceWeb(IRecursosEducativosRepositoryWeb recursosRepository)
        {

            _recursosRepository = recursosRepository;
        }


        public async Task<IEnumerable<RecursosEducativos>> GetAllRecursos()
        {
            return await _recursosRepository.GetAllRecursos();
        }

        public async Task<RecursosEducativos> GetRecursoById(int id)
        {
            return await _recursosRepository.GetRecursoById(id);
        }

        public async Task AddRecurso(RecursosEducativos recurso)
        {
            await _recursosRepository.AddRecurso(recurso);
        }

        public async Task UpdateRecurso(RecursosEducativos recurso)
        {
            await _recursosRepository.UpdateRecurso(recurso);
        }

        public async Task<bool> DeleteRecurso(int id)
        {
            return await _recursosRepository.DeleteRecurso(id);
        }
    }
}
