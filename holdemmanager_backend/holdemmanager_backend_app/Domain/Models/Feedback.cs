using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace holdemmanager_backend_app.Domain.Models
{
    public class Feedback
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int? IdUsuario { get; set; }  

        [Required]
        public DateTime Fecha { get; set; }

        [Required]
        public string Mensaje { get; set; }

        [Required]
        public FeedbackEnum Categoria { get; set; }

        public bool IsAnonimo { get; set; }

        public Jugador? Usuario { get; set; }
    }
}
