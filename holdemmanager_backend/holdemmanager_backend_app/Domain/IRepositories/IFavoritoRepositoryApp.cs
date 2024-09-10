using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface IFavoritoRepositoryApp
    {
        Task<List<int>> GetTorneosFavoritos(int jugadorId);
        Task AddTorneoFavorito(int jugadorId, int torneoId);
        Task<bool> EliminarTorneoFavorito(int jugadorId, int torneoId);
    }
}
