using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace holdemmanager_backend_web.Domain.Models
{
    public class UsuarioWeb
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string NombreUsuario { get; set; }

        [Required]
        public string Password { get; set; }

        [ForeignKey("Id")]
        public List<Torneos> ListaTorneos { get; set; }
    }
}
