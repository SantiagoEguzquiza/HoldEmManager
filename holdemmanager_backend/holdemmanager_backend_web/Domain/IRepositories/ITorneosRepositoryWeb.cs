using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IRepositories
{
    public interface ITorneosRepositoryWeb
    {
        

        Task<List<Torneos>> GetTorneosFiltered(string filtro);
        Task<PagedResult<Torneos>> GetAllTorneos(int page, int pageSize, string filtro, string filtroFecha);
        Task<Torneos> GetTorneoById(int id);
        Task AddTorneo(Torneos torneo);
        Task UpdateTorneo(Torneos torneo);
        Task<bool> DeleteTorneo(int id);
    }
}
