using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace holdemmanager_backend_app.Domain.Models
{
    public class UsuarioApp
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int NumberPlayer { get; set; }
        [Required]
        public string Name { get; set; }    

        [Required]
        public string Email { get; set; }

        [Required]
        public string Password { get; set; }
        public string ImageUrl { get; set; }
    }
}
