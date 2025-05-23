﻿using holdemmanager_backend_app.Domain.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace holdemmanager_backend_app.Utils
{
    public class JwtConfigurator
    {
        public static string GetToken(Jugador userInfo, IConfiguration config)
        {
            string SecretKey = config["Jwt:SecretKey"];
            string Issuer = config["Jwt:Issuer"];
            string Audience = config["Jwt:Audience"];

            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SecretKey));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {

              new Claim(JwtRegisteredClaimNames.Sub,userInfo.Email),
              new Claim("numberPlayer", userInfo.NumberPlayer.ToString())

            };

            var token = new JwtSecurityToken(
                issuer: Issuer,
                audience: Audience,
                claims,
                expires: DateTime.Now.AddDays(1),
                signingCredentials: credentials

                );

            return new JwtSecurityTokenHandler().WriteToken(token);

        }

        public static int GetTokenNumberPlayer(ClaimsIdentity identity) {

            if (identity != null) { 
            
                IEnumerable<Claim> claims = identity.Claims;
                foreach (var claim in claims) {

                    if (claim.Type == "numberPlayer") { 
                    
                        return int.Parse(claim.Value);
                    
                    }
                
                }
            
            }
            return 0;
        
        }
    }
}
