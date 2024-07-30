using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface ITorneosServiceWeb
    {
        Task<IEnumerable<Torneos>> GetAllTorneos();
        Task<Torneos> GetTorneoById(int id);
        Task AddTorneo(Torneos torneo);
        Task UpdateTorneo(Torneos torneo);
        Task<bool> DeleteTorneo(int id);
    }
}