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

        [Required]
        public int TorneoId { get; set; }

        [ForeignKey("TorneoId")]
        public Torneos Torneo { get; set; }

        [Required]
        public int JugadorId { get; set; }

        [ForeignKey("JugadorId")]
        public Jugador Jugador { get; set; }

        [Required]
        public NotificacionEnum TipoEvento { get; set; }

        [Required]
        public DateTime Fecha { get; set; }

        [Required]
        public string Mensaje { get; set; }
    }
}
