using holdemmanager_backend_web.Domain.Excepciones;
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
    public class RankingRepositoryWeb : IRankingRepositoryWeb
    {
        private readonly AplicationDbContextWeb _context;
        public RankingRepositoryWeb(AplicationDbContextWeb context)
        {
            this._context = context;
        }

        public async Task AddRanking(Ranking ranking)
        {
            _context.Rankings.Add(ranking);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteRanking(int id)
        {
            var ranking = await _context.Rankings.Where(x => x.Id == id).FirstOrDefaultAsync();


            if (ranking != null)
            {
                _context.Rankings.Remove(ranking);
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }


        public async Task<IEnumerable<Ranking>> GetAllRankings()
        {
            return await _context.Rankings.ToListAsync();
        }

        public async Task<Ranking> GetRankingById(int id)
        {
            var ranking = await _context.Rankings.Where(x => x.Id == id).FirstOrDefaultAsync();
            if (ranking == null)
            {
                throw new Exception($"El ranking con ID {id} no fue encontrada o no existe.");
            }

            return ranking;
        }

        public async Task<Ranking> GetRankingByNumber(int number)
        {
            var ranking = await _context.Rankings.Where(x => x.PlayerNumber == number).FirstOrDefaultAsync();
            if (ranking == null)
            {
                throw new Exception($"El ranking con Numero de jugador: {number} no fue encontrada o no existe.");
            }

            return ranking;
        }

        public async Task UpdateRanking(Ranking ranking)
        {
            _context.Update(ranking);
            await _context.SaveChangesAsync();
        }
        
    }
}
