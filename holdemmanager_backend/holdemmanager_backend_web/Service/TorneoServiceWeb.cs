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
    public class TorneoServiceWeb : ITorneosServiceWeb
    {
        private readonly ITorneosRepositoryWeb _torneoRepository;
        public TorneoServiceWeb(ITorneosRepositoryWeb torneoRepository)
        {
            _torneoRepository = torneoRepository;
        }
        public async Task AddTorneo(Torneos torneo)
        {
            await _torneoRepository.AddTorneo(torneo);
        }

        public async Task<bool> DeleteTorneo(int id)
        {
            return await _torneoRepository.DeleteTorneo(id);
        }

        public async Task<PagedResult<Torneos>> GetAllTorneos(int page, int pageSize, string filtro, string filtroFecha)
        {
            return await _torneoRepository.GetAllTorneos(page,pageSize, filtro, filtroFecha);
        }

        public async Task<Torneos> GetTorneoById(int id)
        {
            return await _torneoRepository.GetTorneoById(id);
        }

        public async Task UpdateTorneo(Torneos torneo)
        {
            await _torneoRepository.UpdateTorneo(torneo);
        }
    }
}
