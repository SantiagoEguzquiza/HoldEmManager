using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Domain.IServices
{
    public interface IMapaServiceApp
    {
        Task<List<Mapa>> GetMapa();
        Task SavePlano(Mapa mapa);
    }
}
