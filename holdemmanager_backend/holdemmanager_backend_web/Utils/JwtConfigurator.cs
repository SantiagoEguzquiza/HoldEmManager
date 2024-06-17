using holdemmanager_backend_web.Domain.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace holdemmanager_backend_web.Utils
{
    public class JwtConfigurator
    {
        public static string GetToken(UsuarioWeb userInfo, IConfiguration config)
        {
            string SecretKey = config["Jwt:SecretKey"];
            string Issuer = config["Jwt:Issuer"];
            string Audience = config["Jwt:Audience"];

            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SecretKey));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
              new Claim(JwtRegisteredClaimNames.Sub,userInfo.NombreUsuario),
              new Claim("idUsuario", userInfo.Id.ToString())
            };
            
            var token = new JwtSecurityToken(
                issuer: Issuer,
                audience: Audience,
                claims,
                expires: DateTime.Now.AddMinutes(60),
                signingCredentials: credentials

                );

            return new JwtSecurityTokenHandler().WriteToken(token);

        }

        public static int GetTokenNumberPlayer(ClaimsIdentity identity) {

            if (identity != null) { 
            
                IEnumerable<Claim> claims = identity.Claims;
                foreach (var claim in claims) {

                    if (claim.Type == "idUsuario") { 
                    
                        return int.Parse(claim.Value);
                    
                    }
                
                }
            
            }
            return 0;
        
        }
    }
}
