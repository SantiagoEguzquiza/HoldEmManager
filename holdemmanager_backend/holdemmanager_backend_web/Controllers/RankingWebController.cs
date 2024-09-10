using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Utils;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace holdemmanager_backend_web.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class RankingWebController : ControllerBase
    {
        private readonly IRankingServiceWeb _rankingService;
        private readonly AplicationDbContextWeb _dbContext;

        public RankingWebController(AplicationDbContextWeb dbContext, IRankingServiceWeb rankingService)
        {
            _rankingService = rankingService;
            _dbContext = dbContext;

        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPost]
        public async Task<IActionResult> AddRanking([FromBody] Ranking ranking)
        {
            try
            {
                if (ranking == null)
                {
                    return BadRequest(new { message = "El ranking no puede ser nulo." });
                }

                await _rankingService.AddRanking(ranking);

                return Ok(new { message = "Ranking agregado exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet("{id}")]
        public async Task<ActionResult<Noticia>> GetRankingById(int id)
        {
            try
            {
                var ranking = await _rankingService.GetRankingById(id);

                if (ranking == null)
                {
                    return NotFound(new { message = "No se encontraron datos que coincidan con el id." });
                }

                return Ok(ranking);
            }
            catch (Exception)
            {
                return BadRequest(new { message = "No se encontraron datos que coincidan con el id." });
            }
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<Ranking>>> GetAllRankings(RankingEnum tipo, int page, int pageSize)
        {
            var rankings = await _rankingService.GetAllRankings(tipo, page, pageSize);

            return Ok(rankings);
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRanking(int id)
        {
            try
            {
                var ranking = await _rankingService.GetRankingById(id);
                if (ranking == null)
                {
                    return BadRequest(new { message = "El ranking no existe." });
                }



                var deleteResult = await _rankingService.DeleteRanking(id);
                if (deleteResult)
                {
                    return Ok(new { message = "Ranking eliminado exitosamente." });
                }
                else
                {
                    return BadRequest(new { message = "No se pudo eliminar el ranking." });
                }
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Ocurrió un error al intentar eliminar el ranking: {ex.Message}" });
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateRanking(int id, Ranking ranking)
        {
            if (ranking == null || id != ranking.Id)
            {
                return BadRequest(new { message = "ID del ranking no coincide o el ranking es nulo." });
            }

            try
            {
                await _rankingService.UpdateRanking(ranking);
                return Ok(new { message = "Ranking agregado exitosamente." });
            }
            catch (Exception)
            {
                return BadRequest(new { message = "Ranking no encontrado" });

            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPost("importRanking")]
        public async Task<IActionResult> importarRankings([FromBody] Ranking[] rankings)
        {
            try
            {
                foreach (var rank in rankings)
                {
                    if (rank == null)
                    {
                        return BadRequest(new { message = "El ranking no puede ser nulo." });
                    }

                    await _rankingService.AddRanking(rank);

                }
                return Ok(new { message = "Los rankings fueron agregados exitosamente" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }

        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet("getByNumber/{number}")]
        public async Task<ActionResult<RankingHelper>> GetRankingByNumber(int number)
        {
            RankingHelper rankingHelper = new RankingHelper();
            rankingHelper.existingRanking = false;
            try
            {
                var ranking = await _rankingService.GetRankingByNumber(number);
                if (ranking != null)
                {
                    rankingHelper.Ranking = ranking;
                    rankingHelper.existingRanking = true;
                    return Ok(rankingHelper);
                }
                else
                {
                    rankingHelper.Ranking = null;
                    return rankingHelper;
                }

            }
            catch (Exception)
            {
                rankingHelper.Ranking = null;
                return rankingHelper;
            }
        }
    }
}
