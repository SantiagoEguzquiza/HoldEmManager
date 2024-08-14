namespace holdemmanager_reloj.Models
{
    public class BlindLevel
    {
        public int SmallBlind { get; set; }
        public int BigBlind { get; set; }
        public int Ante { get; set; }

        public string BlindText => $"{SmallBlind} / {BigBlind}";

        public override string ToString()
        {
            return $"{SmallBlind}/{BigBlind} Ante: {Ante}";
        }
    }
}
