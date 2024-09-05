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
    public class RankingServiceWeb : IRankingServiceWeb
    {
        private readonly IRankingRepositoryWeb _rankingRepository;

        public RankingServiceWeb(IRankingRepositoryWeb rankingRepository)
        {
            _rankingRepository = rankingRepository;
        }

        public async Task AddRanking(Ranking ranking)
        {
            await _rankingRepository.AddRanking(ranking);
        }

        public async Task<bool> DeleteRanking(int id)
        {
            return await _rankingRepository.DeleteRanking(id);
        }

        public async Task<IEnumerable<Ranking>> GetAllRankings()
        {
            return await _rankingRepository.GetAllRankings();
        }

        public async Task<Ranking> GetRankingById(int id)
        {
            return await _rankingRepository.GetRankingById(id);
        }

        public async Task<Ranking> GetRankingByNumber(int number)
        {
            return await _rankingRepository.GetRankingByNumber((int)number);
        }

        public async Task UpdateRanking(Ranking ranking)
        {
            await _rankingRepository.UpdateRanking(ranking);
        }

    }
}
