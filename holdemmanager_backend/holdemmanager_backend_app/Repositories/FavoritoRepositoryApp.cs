using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Repositories
{
    public class FavoritoRepositoryApp : IFavoritoRepositoryApp
    {
        private readonly AplicationDbContextApp _context;
        public FavoritoRepositoryApp(AplicationDbContextApp context)
        {
            this._context = context;
        }
        public async Task AddTorneoFavorito(int jugadorId, int torneoId)
        {
            try
            {
                var favExistente = await _context.Favoritos.FirstOrDefaultAsync(f => f.JugadorId == jugadorId && f.TorneoId == torneoId);

                if (favExistente == null)
                {
                    var favorito = new Favorito
                    {
                        JugadorId = jugadorId,
                        TorneoId = torneoId
                    };

                    _context.Favoritos.Add(favorito);
                    await _context.SaveChangesAsync();
                } else
                {
                    throw new Exception("El torneo ya está en la lista de favoritos.");
                }
            }
            catch (Exception)
            {
                throw new Exception("Error al agregar torneo a favoritos");
            }
        }

        public async Task<bool> EliminarTorneoFavorito(int jugadorId, int torneoId)
        {
            try
            {
                var favorito = await _context.Favoritos.FirstOrDefaultAsync(f => f.JugadorId == jugadorId && f.TorneoId == torneoId);

                if (favorito != null)
                {
                    _context.Favoritos.Remove(favorito);
                    await _context.SaveChangesAsync();

                    return true;
                }

                return false;
            }
            catch (Exception)
            {
                throw new Exception("Error al eliminar torneo de favoritos");
            }
        }

        public async Task<List<int>> GetTorneosFavoritos(int jugadorId)
        {
            return await _context.Favoritos
            .Where(f => f.JugadorId == jugadorId)
            .Select(f => f.TorneoId)
            .ToListAsync();
        }
    }
}
