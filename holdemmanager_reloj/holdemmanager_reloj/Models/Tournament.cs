using System.Collections.ObjectModel;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace holdemmanager_reloj.Models
{
    public class Tournament : INotifyPropertyChanged 
    {
        [Key]
        public int TournamentId { get; set; }

        [Required]
        [MaxLength(100)]
        public string TournamentName { get; set; }

        public int Level { get; set; }
        public int? TotalEntries { get; set; }
        public DateTime FechaInicio { get; set; }
        public decimal? AverageChips { get; set; }
        public decimal? PrizePool { get; set; }
        

        public virtual ICollection<BlindLevel> Levels { get; set; }

        public Tournament()
        {
            Levels = new ObservableCollection<BlindLevel>();
        }


        private int? _totalInscriptions;

        public int? TotalInscriptions
        {
            get { return _totalInscriptions; }
            set
            {
                if (_totalInscriptions != value)
                {
                    
                    _totalInscriptions = value;
                    OnPropertyChanged(nameof(TotalInscriptions));
                    CalculateAverageChips();
                    calculatePrizePool();

                }
            }
        }

        private int? _participantsRemaining;

        public int? ParticipantsRemaining
        {
            get { return _participantsRemaining; }
            set
            {
                if (_participantsRemaining != value)
                {
                    _participantsRemaining = value;
                    OnPropertyChanged(nameof(ParticipantsRemaining));
                    CalculateAverageChips();
                    calculatePrizePool();
                }
            }
        }

        private int? _totalRebuys;
        public int? TotalRebuys
        {
            get { return _totalRebuys; }
            set
            {
                if (_totalRebuys != value)
                {
                    _totalRebuys = value;
                    OnPropertyChanged(nameof(TotalRebuys));
                    CalculateAverageChips();
                    calculatePrizePool();
                }
            }
        }

        private int? _countRebuys;
        public int? CountRebuys
        {
            get { return _countRebuys; }
            set
            {
                if (_countRebuys != value)
                {
                    _countRebuys = value;
                    OnPropertyChanged(nameof(CountRebuys));
                    CalculateAverageChips();
                    calculatePrizePool();
                }
            }
        }

        private int? _chipsRebuys;
        public int? ChipsRebuys
        {
            get { return _chipsRebuys; }
            set
            {
                if (_chipsRebuys != value)
                {
                    _chipsRebuys = value;
                    OnPropertyChanged(nameof(ChipsRebuys));
                    CalculateAverageChips();
                    calculatePrizePool();
                }
            }
        }

        private int? _totalAddOn;
        public int? TotalAddOn
        {
            get { return _totalAddOn; }
            set
            {
                if (_totalAddOn != value)
                {
                    _totalAddOn = value;
                    OnPropertyChanged(nameof(TotalAddOn));
                    CalculateAverageChips();
                    calculatePrizePool();
                }
            }
        }

        private int? _countAddOn;
        public int? CountAddOn
        {
            get { return _countAddOn; }
            set
            {
                if (_countAddOn != value)
                {
                    _countAddOn = value;
                    OnPropertyChanged(nameof(CountAddOn));
                    CalculateAverageChips();
                    calculatePrizePool();
                }
            }
        }

        private int? _chipsAddon;
        public int? ChipsAddon
        {
            get { return _chipsAddon; }
            set
            {
                if (_chipsAddon != value)
                {
                    _chipsAddon = value;
                    OnPropertyChanged(nameof(ChipsAddon));
                    CalculateAverageChips();
                    calculatePrizePool();
                }
            }
        }

        private int? _countInscriptions;
        public int? CountInscriptions
        {
            get { return _countInscriptions; }
            set
            {
                if (_countInscriptions != value)
                {
                    _countInscriptions = value;
                    OnPropertyChanged(nameof(CountInscriptions));
                    CalculateAverageChips();
                    calculatePrizePool();
                }
            }
        }

        private int? _chipsInscriptions;
        public int? ChipsInscriptions
        {
            get { return _chipsInscriptions; }
            set
            {
                if (_chipsInscriptions != value)
                {
                    _chipsInscriptions = value;
                    OnPropertyChanged(nameof(ChipsInscriptions));
                    CalculateAverageChips();
                    calculatePrizePool();
                }
            }
        }

        private void CalculateAverageChips()
        {
            var chipsInscriptions = ChipsInscriptions * TotalInscriptions;
            var chipsRebuys = ChipsRebuys * TotalRebuys;
            var chipsAddon = ChipsAddon * TotalAddOn;
            var totalChips = chipsInscriptions + chipsRebuys + chipsAddon;

            if (ParticipantsRemaining > 0)
            {
                AverageChips = totalChips / ParticipantsRemaining;
                OnPropertyChanged(nameof(AverageChips));
            }
        }

        private void calculatePrizePool()
        {
            var prizeInscriptions = CountInscriptions * TotalInscriptions;
            var prizeRebuys = CountRebuys * TotalRebuys;
            var prizeAddon = CountAddOn * TotalAddOn;
            var totalPrize = prizeInscriptions + prizeRebuys + prizeAddon;

            PrizePool = totalPrize;
            OnPropertyChanged(nameof(PrizePool));
        }


        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
