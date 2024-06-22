using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.Models
{
    public class Contacto
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string InfoCasino { get; set; }

        [Required]
        public string Direccion { get; set; }

        [Required]
        public string NumeroTelefono { get; set; }

        [Required]
        public string Email { get; set; }


    }
}
