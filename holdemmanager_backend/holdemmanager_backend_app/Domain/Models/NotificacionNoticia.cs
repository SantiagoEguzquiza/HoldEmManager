using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.Models
{
    public class NotificacionNoticia
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int JugadorId { get; set; }

        [Required]
        public NotificacionNoticiaEnum TipoEvento { get; set; }

        [Required]
        public DateTime Fecha { get; set; }

        [Required]
        public string Mensaje { get; set; }
    }
}
