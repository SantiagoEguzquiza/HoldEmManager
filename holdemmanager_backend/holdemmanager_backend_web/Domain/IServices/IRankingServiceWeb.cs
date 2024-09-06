using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface IRankingServiceWeb
    {

        Task<IEnumerable<Ranking>> GetAllRankings();
        Task<Ranking> GetRankingById(int id);
        Task<Ranking> GetRankingByNumber(int number);
        Task AddRanking(Ranking ranking);
        Task UpdateRanking(Ranking ranking);
        Task<bool> DeleteRanking(int id);

    }
}
