using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_app.Service
{
    public class MapaServiceApp : IMapaServiceApp
    {
        private readonly IMapaRepositoryApp _mapaRepository;

        public MapaServiceApp(IMapaRepositoryApp mapaRepository)
        {

            _mapaRepository = mapaRepository;
        }

        public async Task<List<Mapa>> GetMapa()
        {
            return await _mapaRepository.GetMapa();
        }

        public async Task SavePlano(Mapa mapa)
        {
           await _mapaRepository.SavePlano(mapa);
        }
    }
}
