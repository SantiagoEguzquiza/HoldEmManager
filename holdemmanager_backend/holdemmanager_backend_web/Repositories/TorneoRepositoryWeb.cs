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

        public async Task<PagedResult<Torneos>> GetAllTorneos(int page, int pageSize)
        {
            var torneos = await _context.Torneos
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
