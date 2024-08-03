using holdemmanager_backend_web.Domain.Excepciones;
using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Repositories
{
    public class RankingRepositoryWeb : IRankingRepositoryWeb
    {
        private readonly AplicationDbContextWeb _context;
        public RankingRepositoryWeb(AplicationDbContextWeb context)
        {
            this._context = context;
        }
       
    }
}
