using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Utils;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Repositories
{
    public class TorneoRepositoryWeb : ITorneosRepositoryWeb
    {
        private readonly AplicationDbContextWeb _context;
        public TorneoRepositoryWeb(AplicationDbContextWeb context)
        {
            this._context = context;
        }
        public async Task AddTorneo(Torneos torneo)
        {
            _context.Torneos.Add(torneo);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteTorneo(int id)
        {
            var torneo = await _context.Torneos.Where(c => c.Id == id).FirstOrDefaultAsync();

            if (torneo != null)
            {
                _context.Torneos.Remove(torneo);
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public async Task<PagedResult<Torneos>> GetAllTorneos(int page, int pageSize, string filtro, string filtroFecha)
        {
            var query = _context.Torneos.AsQueryable();

            if (!string.IsNullOrWhiteSpace(filtro))
            {
                query = query.Where(r => r.Nombre.Contains(filtro) || r.numeroRef.Contains(filtro));
            }

            if (!string.IsNullOrEmpty(filtroFecha) && filtroFecha != "null")
            {
                if (DateTime.TryParse(filtroFecha, out DateTime fechaParsed))
                {
                    query = query.Where(r => r.Fecha.Date == fechaParsed.Date);
                }
            }

            var totalItems = await query.CountAsync();


            var torneos = await query
                                 .Skip((page - 1) * pageSize)
                                 .Take(pageSize + 1)
                                 .ToListAsync();

            var hasNextPage = torneos.Count > pageSize;

            if (hasNextPage)
            {
                torneos.RemoveAt(pageSize);
            }

            return new PagedResult<Torneos>
            {
                Items = torneos,
                HasNextPage = hasNextPage
            };
        }
        public async Task<List<Torneos>> GetTorneosFiltered(string filtro)
        {
            var query = _context.Torneos.AsQueryable();

            if (!string.IsNullOrWhiteSpace(filtro))
            {
                query = query.Where(t => t.Nombre.Contains(filtro));
            }

            var torneos = await query.ToListAsync();

            return torneos;
        }

        public async Task<Torneos> GetTorneoById(int id)
        {
            var torneo = await _context.Torneos.Where(c => c.Id == id).FirstOrDefaultAsync();
            if (torneo == null)
            {
                throw new Exception($"El torneo con id {id} no fue encontrado o no existe");
            }

            return torneo;
        }


        public async Task UpdateTorneo(Torneos torneo)
        {
            _context.Update(torneo);
            await _context.SaveChangesAsync();
        }
    }
}
