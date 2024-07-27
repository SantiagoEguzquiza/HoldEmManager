using System.ComponentModel.DataAnnotations;

namespace holdemmanager_backend_web.Domain.Models
{
    public class Noticia
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Titulo { get; set; }

        public DateTime Fecha { get; set; }

        [Required]
        public string Mensaje { get; set; }

        public string? IdImagen { get; set; }
    }
}
