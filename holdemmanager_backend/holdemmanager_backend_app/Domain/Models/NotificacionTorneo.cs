using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.Models
{
    public class NotificacionTorneo
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int TorneoId { get; set; }

        public int JugadorId { get; set; }

        [Required]
        public NotificacionTorneoEnum TipoEvento { get; set; }

        [Required]
        public DateTime Fecha { get; set; }

        [Required]
        public string Mensaje { get; set; }
    }
}
