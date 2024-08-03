using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace holdemmanager_backend_web.Domain.Models
{
    public class Ranking
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        [Required]
        public int PlayerNumber { get; set; }
        [Required]
        public string PlayerName { get; set; }
        [Required]
        public int Puntuacion { get; set; }
        [Required]
        public RankingEnum RankingEnum { get; set; }

    }
}
