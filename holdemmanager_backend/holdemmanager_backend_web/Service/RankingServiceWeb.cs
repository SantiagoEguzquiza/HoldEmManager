using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Service
{
    public class RankingServiceWeb : IRankingServiceWeb
    {
        private readonly IRecursosEducativosRepositoryWeb _recursosRepository;

        public RankingServiceWeb(IRecursosEducativosRepositoryWeb recursosRepository)
        {

        }


    }
}
