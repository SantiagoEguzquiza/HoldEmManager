using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.Models
{
    public class Mapa
    {
        [Key]
        public int? Id { get; set; }
        public int PlanoId { get; set; }
        public byte[] Plano { get; set; }
    }
}
