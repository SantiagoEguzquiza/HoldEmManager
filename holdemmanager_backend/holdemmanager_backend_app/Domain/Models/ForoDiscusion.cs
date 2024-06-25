using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.Models
{
    public class ForoDiscusion
    {
        [ForeignKey("Id")]
        public Jugador idUsuario { get; set; }

        [Required]
        public DateTime Fecha { get; set; }
        [Required]
        public string Mensaje { get; set; }
    }
}
