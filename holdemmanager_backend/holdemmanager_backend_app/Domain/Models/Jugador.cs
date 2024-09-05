using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace holdemmanager_backend_app.Domain.Models
{
    public class Jugador
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
        public string? ImageUrl { get; set; }
        public List<Feedback> Feedbacks { get; set; } = new List<Feedback>();
    }
}
