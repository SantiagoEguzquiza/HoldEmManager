using holdemmanager_reloj.Commands;
using holdemmanager_reloj.Models;
using System;
using System.ComponentModel;
using System.Windows.Input;
using holdemmanager_reloj.Helpers;
using System.Linq;
using holdemmanager_reloj.Services;
using System.Timers;

namespace holdemmanager_reloj.ViewModels
{
    public class BlindClockViewModel : INotifyPropertyChanged
    {
        private readonly BlindClockService _blindService;
        private NotificationHelper notificationHelper = new NotificationHelper();

        private Tournament _tournament;
        private BlindLevel _currentLevel;
        private BlindLevel _nextLevel;
        private TimeSpan _timeToNextBreak;
        private System.Timers.Timer _timer;
        private System.Timers.Timer _breakTimer;
        private bool _isTimingPaused = true;
        private bool _isConfiguring = false;
        private bool _isBreak;
        private bool _isPaused;
        private string _endGameMessage;

        public bool IsBreak
        {
            get => _isBreak;
            set
            {
                if (_isBreak != value)
                {
                    _isBreak = value;
                    OnPropertyChanged(nameof(IsBreak));
                }
            }
        }

        public bool IsPaused
        {
            get => _isPaused;
            set
            {
                if (_isPaused != value)
                {
                    _isPaused = value;
                    OnPropertyChanged(nameof(IsPaused));
                }
            }
        }

        public TimeSpan TimeToNextBreak
        {
            get => _timeToNextBreak;
            set
            {
                if (_timeToNextBreak != value)
                {
                    _timeToNextBreak = value;
                    OnPropertyChanged(nameof(TimeToNextBreak));
                }
            }
        }

        public Tournament Tournament
        {
            get => _tournament;
            set
            {
                if (_tournament != value)
                {
                    _tournament = value;
                    OnPropertyChanged(nameof(Tournament));
                }
            }
        }

        public BlindLevel CurrentLevel
        {
            get => _currentLevel;
            set
            {
                if (_currentLevel != value)
                {
                    _currentLevel = value;
                    OnPropertyChanged(nameof(CurrentLevel));
                    IsBreak = _currentLevel.BlindType == BlindTypeEnum.Break;
                }
            }
        }

        public BlindLevel NextLevel
        {
            get => _nextLevel;
            set
            {
                if (_nextLevel != value)
                {
                    _nextLevel = value;
                    OnPropertyChanged(nameof(NextLevel));
                }
            }
        }

        public bool IsConfiguring
        {
            get => _isConfiguring;
            set
            {
                if (_isConfiguring != value)
                {
                    _isConfiguring = value;
                    OnPropertyChanged(nameof(IsConfiguring));
                }
            }
        }

        public string EndGameMessage
        {
            get => _endGameMessage;
            set
            {
                if (_endGameMessage != value)
                {
                    _endGameMessage = value;
                    OnPropertyChanged(nameof(EndGameMessage));
                }
            }
        }

        public ICommand StartCommand { get; }
        public ICommand PauseCommand { get; }
        public ICommand ResetCommand { get; }
        public ICommand ToSubtractPlayer { get; }

        public BlindClockViewModel(Tournament tournament)
        {
            Tournament = tournament ?? throw new ArgumentNullException(nameof(tournament));
            _blindService = new BlindClockService();

            if (Tournament.Levels != null && Tournament.Levels.Any())
            {
                CurrentLevel = Tournament.Levels.First();
                UpdateNextLevelInfo();
            }

            _timer = new System.Timers.Timer(1000); // Intervalo de 1 segundo
            _timer.Elapsed += OnTimerTick;
            _timer.AutoReset = true;

            _breakTimer = new System.Timers.Timer(1000); // Intervalo de 1 segundo
            _breakTimer.Elapsed += OnBreakTimerTick;
            _breakTimer.AutoReset = true;

            StartCommand = new RelayCommand(StartTournament);
            PauseCommand = new RelayCommand(ToggleTimer);
            ToSubtractPlayer = new RelayCommand(RestarPlayer);
        }

        private void StartTournament()
        {
            IsConfiguring = false;
            _isTimingPaused = false;
            IsPaused = false;
            EndGameMessage = string.Empty;

            _timer.Start();
            StartBreakTimer();
        }

        private void OnTimerTick(object sender, ElapsedEventArgs e)
        {
            App.Current.Dispatcher.Invoke(() =>
            {
                if (CurrentLevel?.Duration.TotalSeconds > 1)
                {
                    CurrentLevel.Duration = CurrentLevel.Duration.Subtract(TimeSpan.FromSeconds(1));
                    OnPropertyChanged(nameof(CurrentLevel));
                }
                else if (CurrentLevel?.Duration.TotalSeconds == 1)
                {
                    CurrentLevel.Duration = TimeSpan.Zero;
                    OnPropertyChanged(nameof(CurrentLevel));
                    MoveToNextLevel(); 
                }
                else
                {
                    MoveToNextLevel();
                }
            });
        }

        private void OnBreakTimerTick(object sender, ElapsedEventArgs e)
        {
            App.Current.Dispatcher.Invoke(() =>
            {
                if (_breakTimer != null && TimeToNextBreak.TotalSeconds > 0)
                {
                    TimeToNextBreak = TimeToNextBreak.Subtract(TimeSpan.FromSeconds(1));
                }
                else
                {
                    _breakTimer?.Stop();
                    MoveToNextLevel();
                }
            });
        }

        private void MoveToNextLevel()
        {
            var nextLevel = _blindService.GetNextLevel(Tournament, CurrentLevel);
            if (nextLevel == null)
            {
                _timer.Stop();
                _breakTimer?.Stop();
                EndGameMessage = "Juego terminado";
            }
            else
            {
                CurrentLevel = nextLevel;
                UpdateNextLevelInfo();
            }
        }

        private void StartBreakTimer()
        {
            if (_breakTimer != null && TimeToNextBreak.TotalSeconds > 0)
            {
                _breakTimer.Start();
            }
        }

        private void RestarPlayer()
        {
            Tournament.ParticipantsRemaining--;
            OnPropertyChanged(nameof(Tournament));
        }

        private void ToggleTimer()
        {
            if (_isTimingPaused)
            {
                _timer.Start();
                _breakTimer?.Start();
                _isTimingPaused = false;
                IsPaused = false;
            }
            else
            {
                _timer.Stop();
                _breakTimer?.Stop();
                _isTimingPaused = true;
                IsPaused = true;
            }
        }

        private void UpdateNextLevelInfo()
        {
            NextLevel = _blindService.GetNextLevel(Tournament, CurrentLevel);
            if (CurrentLevel.BlindType != BlindTypeEnum.Break)
            {
                TimeToNextBreak = _blindService.GetNextBreakTiming(Tournament, CurrentLevel);
                StartBreakTimer();
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}