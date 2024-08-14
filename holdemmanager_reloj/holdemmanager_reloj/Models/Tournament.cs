namespace holdemmanager_reloj.Models
{
    public class Tournament
    {
        public string TournamentName { get; set; }
        public int Level { get; set; }
        public int TotalEntries { get; set; }
        public int ParticipantsRemaining { get; set; }
        public int Rebuys { get; set; }
        public TimeSpan TimeRemainingForNextBreak { get; set; }
        public decimal AverageChips { get; set; }
        public decimal PrizePool { get; set; }

        public BlindLevel CurrentBlindLevel { get; set; }
        public BlindLevel NextBlindLevel { get; set; }
    }
}
