using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.Models
{
    public class Torneos
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Nombre { get; set; }

        public DateTime Horario { get; set; }

        public string Premios { get; set; }

        [ForeignKey("Id")]
        public List<UsuarioWeb> ListaJugadores { get; set; }
    }
}
