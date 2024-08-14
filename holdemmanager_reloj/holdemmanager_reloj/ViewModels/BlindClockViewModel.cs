using holdemmanager_reloj.Commands;
using holdemmanager_reloj.Models;
using holdemmanager_reloj.Services;
using System.ComponentModel;
using System.Windows.Input;

namespace holdemmanager_reloj.ViewModels
{
    public class BlindClockViewModel : INotifyPropertyChanged
    {
        private string _clockTime;
        private Tournament _tournament;
        private BlindClockService _blindClockService;

        public event PropertyChangedEventHandler PropertyChanged;

        public BlindClockViewModel()
        {
            // Inicializar el torneo y el servicio
            _tournament = new Tournament
            {
                TournamentName = "Torneo Martes - USD 100",
                Level = 1,
                TotalEntries = 37,
                ParticipantsRemaining = 37,
                Rebuys = 0,
                TimeRemainingForNextBreak = new TimeSpan(1, 43, 22),
                AverageChips = 12432,
                PrizePool = 3330,
                CurrentBlindLevel = new BlindLevel { SmallBlind = 25, BigBlind = 50, Ante = 50 },
                NextBlindLevel = new BlindLevel { SmallBlind = 50, BigBlind = 100, Ante = 100 }
            };

            _clockTime = "30:00"; // Tiempo inicial

            _blindClockService = new BlindClockService(_tournament);
            _blindClockService.OnClockTick += UpdateClockTime;
            _blindClockService.OnLevelChange += UpdateBlindLevel;
            _blindClockService.OnBreakTimeUpdate += UpdateBreakTime;
        }

        public Tournament Tournament
        {
            get => _tournament;
            set
            {
                _tournament = value;
                OnPropertyChanged(nameof(Tournament));
            }
        }

        public string ClockTime
        {
            get => _clockTime;
            set
            {
                _clockTime = value;
                OnPropertyChanged(nameof(ClockTime));
            }
        }

        public ICommand StartCommand => new RelayCommand(StartClock);

        private void StartClock(object obj)
        {
            _blindClockService.Start();
        }

        private void UpdateClockTime(string newTime)
        {
            ClockTime = newTime;
        }

        private void UpdateBlindLevel(BlindLevel newLevel)
        {
            Tournament.CurrentBlindLevel = newLevel;
        }

        private void UpdateBreakTime(TimeSpan newTime)
        {
            Tournament.TimeRemainingForNextBreak = newTime;
            OnPropertyChanged(nameof(Tournament.TimeRemainingForNextBreak));
        }

        protected virtual void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
