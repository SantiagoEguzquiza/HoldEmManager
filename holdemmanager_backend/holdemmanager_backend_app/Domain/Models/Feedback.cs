using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace holdemmanager_backend_app.Domain.Models
{
    public class Feedback
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("Id")]
        public Jugador idUsuario { get; set; }

        [Required]
        public DateTime Fecha { get; set; }
        [Required]
        public string Mensaje { get; set; }
    }
}
