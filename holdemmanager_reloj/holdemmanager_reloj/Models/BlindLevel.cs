using holdemmanager_reloj.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace holdemmanager_reloj.Models
{
    public class BlindLevel
    {
        public int BlindLevelId { get; set; }
        public int? Level { get; set; }
        public int SmallBlind { get; set; }
        public int BigBlind { get; set; }
        public int Ante { get; set; }
        public TimeSpan Duration { get; set; }

        [Required]
        public BlindTypeEnum BlindType { get; set; }

        [NotMapped]
        public string DurationString { get; set; }

        [ForeignKey("Tournament")]
        public int TournamentId { get; set; }
        public virtual Tournament Tournament { get; set; }
        public string BlindText => $"{SmallBlind} / {BigBlind}";

        public override string ToString()
        {
            return $"{SmallBlind}/{BigBlind} Ante: {Ante}";
        }

        public void ConvertDurationToTimeSpan()
        {
            if (string.IsNullOrWhiteSpace(DurationString))
            {
                Duration = TimeSpan.Zero;
                return;
            }

            var match = Regex.Match(DurationString, @"(\d+)");
            if (match.Success && int.TryParse(match.Value, out int minutes))
            {
                Duration = TimeSpan.FromMinutes(minutes);
            }
            else
            {
                Duration = TimeSpan.Zero;
            }
        }

        public void ConvertTimeSpanToDurationString()
        {
            if (Duration == TimeSpan.Zero)
            {
                DurationString = "1 min";
                return;
            }

            if (BlindType == BlindTypeEnum.Break)
            {
                DurationString = $"{Duration:mm}";
            }
            else
            {
                DurationString = $"{Duration:mm} min";
            }
        }
    }
}