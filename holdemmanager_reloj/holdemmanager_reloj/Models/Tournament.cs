using System.Collections.ObjectModel;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace holdemmanager_reloj.Models
{
    public class Tournament
    {
        [Key]
        public int TournamentId { get; set; }

        [Required]
        [MaxLength(100)]
        public string TournamentName { get; set; }

        public int Level { get; set; }
        public int TotalEntries { get; set; }
        public int? ParticipantsRemaining { get; set; }
        public int? TotalRebuys { get; set; }
        public int? CountRebuys { get; set; }
        public int ChipsRebuys { get; set; }
        public DateTime FechaInicio { get; set; }
        public int? TotalInscriptions { get; set; }
        public int? CountInscriptions { get; set; }
        public int ChipsInscriptions { get; set; }
        public decimal? AverageChips { get; set; }
        public decimal? PrizePool { get; set; }
        public int TotalAddOn { get; set; }
        public int CountAddOn { get; set; }
        public int ChipsAddon { get; set; }

        public virtual ICollection<BlindLevel> Levels { get; set; }

        public Tournament()
        {
            Levels = new ObservableCollection<BlindLevel>();
        }
    }
}
