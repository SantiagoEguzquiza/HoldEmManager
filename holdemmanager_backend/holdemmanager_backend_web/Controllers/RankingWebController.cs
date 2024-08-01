using holdemmanager_backend_web.Domain.Excepciones;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class RankingWebController : ControllerBase
    {
        
    }
}
