using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Utils;
using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.IServices
{
    public interface IFavoritoServiceApp
    {
        Task<List<int>> GetTorneosFavoritos(int jugadorId);
        Task AddTorneoFavorito(int jugadorId, int torneoId);
        Task<bool> EliminarTorneoFavorito(int jugadorId, int torneoId);
    }
}
