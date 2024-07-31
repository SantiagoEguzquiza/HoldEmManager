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
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        public string numeroRef { get; set; }

        [Required]
        public string Inicio { get; set; }

        [Required]
        public string Cierre { get; set; }

        [Required]
        public string Nombre { get; set; }

        [Required]
        public string Stack { get; set; }

        [Required]
        public string Niveles { get; set; }

        [Required]
        public DateTime Fecha { get; set; }

        [Required]
        public string Entrada { get; set; }
    }
}
