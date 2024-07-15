using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface IMapaRepositoryApp
    {

        Task<List<Mapa>> GetMapa();
        Task SavePlano(Mapa mapa);
    }
}
