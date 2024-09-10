using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.Models
{
    public class Favorito
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int JugadorId { get; set; }

        [Required]
        public int TorneoId { get; set; } 

        [ForeignKey("JugadorId")]
        public Jugador Jugador { get; set; }
    }
}
