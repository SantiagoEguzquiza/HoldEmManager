using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Service
{
    public class FavoritoServiceApp : IFavoritoServiceApp
    {
        private readonly IFavoritoRepositoryApp _favoritoRepositoryApp;
        public FavoritoServiceApp(IFavoritoRepositoryApp favoritoRepositoryApp)
        {
            _favoritoRepositoryApp = favoritoRepositoryApp;
        }
        public async Task AddTorneoFavorito(int jugadorId, int torneoId)
        {
            await _favoritoRepositoryApp.AddTorneoFavorito(jugadorId, torneoId);
        }

        public async Task<bool> EliminarTorneoFavorito(int jugadorId, int torneoId)
        {
            return await _favoritoRepositoryApp.EliminarTorneoFavorito(jugadorId, torneoId);
        }

        public async Task<List<int>> GetTorneosFavoritos(int jugadorId)
        {
            return await _favoritoRepositoryApp.GetTorneosFavoritos(jugadorId);
        }
    }
}
