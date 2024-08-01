using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_app.Utils;
using Microsoft.EntityFrameworkCore;

namespace holdemmanager_backend_app.Persistence.Repositories
{
    public class MapaRepositoryApp : IMapaRepositoryApp
    {
        private readonly AplicationDbContextApp _context;
        public MapaRepositoryApp(AplicationDbContextApp context)
        {
            this._context = context;
        }

        public async Task<List<Mapa>> GetMapa()
        {
            List<Mapa> mapas = await _context.Mapa.ToListAsync();
            return mapas;
        }

        public async Task SavePlano(Mapa mapa)
        {
            var mapaActualizado = await _context.Mapa.Where(u => u.PlanoId == mapa.PlanoId).FirstOrDefaultAsync();
            if (mapaActualizado != null)
            {
                mapaActualizado.Plano = mapa.Plano;
                mapaActualizado.PlanoId = mapa.PlanoId;

                _context.Mapa.Update(mapaActualizado);
                await _context.SaveChangesAsync();
            }
            else {
                await _context.Mapa.AddAsync(mapa);
                await _context.SaveChangesAsync();
            }
           
        }
    }
}
