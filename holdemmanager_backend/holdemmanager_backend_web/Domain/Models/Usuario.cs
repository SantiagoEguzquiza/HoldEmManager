using System.ComponentModel.DataAnnotations;

namespace holdemmanager_backend_web.Domain.Models
{
    public class UsuarioWeb
    {
        public int Id { get; set; }

        [Required]
        public string NombreUsuario { get; set; }

        [Required]
        public string Password { get; set; }    
    }
}
