using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Persistence
{
    public class DefaultUsers
    {
        public static void create(AplicationDbContextWeb _context)
        {
            if (_context.Usuarios.Any()) { return; }

            _context.Usuarios.Add(new UsuarioWeb { NombreUsuario = "PokerAdmin", Password = Encriptar.EncriptarPassword("poker123"), Rol = RolesEnum.ADMINISTRACION});
            _context.Usuarios.Add(new UsuarioWeb { NombreUsuario = "PrensaAdmin", Password = Encriptar.EncriptarPassword("prensa123"), Rol = RolesEnum.PRENSA});

            _context.SaveChanges();

        }
    }
}
