using holdemmanager_backend_web.Domain.Excepciones;
using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Repositories
{
    public class RecursosEducativosRepositoryWeb : IRecursosEducativosRepositoryWeb
    {
        private readonly AplicationDbContextWeb _context;
        public RecursosEducativosRepositoryWeb(AplicationDbContextWeb context)
        {
            this._context = context;
        }
        public async Task<IEnumerable<RecursosEducativos>> GetAllRecursos()
        {
            return await _context.RecursosEducativos.ToListAsync();
        }

        public async Task<RecursosEducativos> GetRecursoById(int id)
        {
            var recurso = await _context.RecursosEducativos.Where(x => x.Id == id).FirstOrDefaultAsync();
            if (recurso == null)
            {
                throw new RecursoNoEncontradoException($"El recurso con ID {id} no fue encontrado o no existe.");
            }

            return recurso;
        }

        public async Task AddRecurso(RecursosEducativos recurso)
        {
            _context.RecursosEducativos.Add(recurso);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateRecurso(RecursosEducativos recurso)
        {
            _context.RecursosEducativos.Update(recurso);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteRecurso(int id)
        {
            var recurso = await _context.RecursosEducativos.Where(x => x.Id == id).FirstOrDefaultAsync();

            if (recurso != null)
            {
                _context.RecursosEducativos.Remove(recurso);
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
