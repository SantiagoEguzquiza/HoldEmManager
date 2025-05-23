﻿using holdemmanager_backend_web.Domain.Excepciones;
using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Utils;
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
        public async Task<PagedResult<RecursoEducativo>> GetAllRecursos(int page, int pageSize, string filtro)
        {
            var query = _context.RecursosEducativos.AsQueryable();

            if (!string.IsNullOrWhiteSpace(filtro))
            {
                query = query.Where(r => r.Titulo.Contains(filtro) || r.Mensaje.Contains(filtro));
            }

            var totalItems = await query.CountAsync();

            var recursos = await query
                                 .Skip((page - 1) * pageSize)
                                 .Take(pageSize + 1)
                                 .ToListAsync();

            var hasNextPage = recursos.Count > pageSize;

            if (hasNextPage)
            {
                recursos.RemoveAt(pageSize);
            }

            return new PagedResult<RecursoEducativo>
            {
                Items = recursos,
                HasNextPage = hasNextPage
            };
        }

        public async Task<RecursoEducativo> GetRecursoById(int id)
        {
            var recurso = await _context.RecursosEducativos.Where(x => x.Id == id).FirstOrDefaultAsync();
            if (recurso == null)
            {
                throw new RecursoNoEncontradoException($"El recurso con ID {id} no fue encontrado o no existe.");
            }

            return recurso;
        }

        public async Task AddRecurso(RecursoEducativo recurso)
        {
            _context.RecursosEducativos.Add(recurso);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateRecurso(RecursoEducativo recurso)
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
