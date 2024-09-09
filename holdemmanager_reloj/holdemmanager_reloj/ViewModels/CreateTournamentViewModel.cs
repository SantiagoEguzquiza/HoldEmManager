using Flattinger.Core.Interface.ToastMessage;
using Flattinger.Core.Theme;
using Flattinger.UI.ToastMessage;
using Flattinger.UI.ToastMessage.Controls;
using holdemmanager_reloj.Commands;
using holdemmanager_reloj.Models;
using holdemmanager_reloj.Services;
using holdemmanager_reloj.Views;
using Microsoft.IdentityModel.Tokens;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows;
using System.Windows.Input;
using Application = System.Windows.Application;
using MessageBox = System.Windows.MessageBox;

namespace holdemmanager_reloj.ViewModels
{
    public class CreateTournamentViewModel : INotifyPropertyChanged
    {
        private readonly TournamentService _tournamentService;

        private readonly NavigationService _navigationService;

        private AlertServices AlertServices;

        public ObservableCollection<BlindLevel> Levels { get; set; }

        public ICommand SaveCommand { get; }
        public ICommand CancelCommand { get; }
        public ICommand AddNewLevelCommand { get; }
        public ICommand AddBreakCommand { get; }
        public ICommand DeleteLevelCommand { get; }
        public ICommand SendTestNotification { get; }

        private bool _isSaving;
        public bool IsSaving
        {
            get => _isSaving;
            set
            {
                _isSaving = value;
                OnPropertyChanged(nameof(IsSaving));
                OnPropertyChanged(nameof(LoadingVisibility));
            }
        }

        public Visibility LoadingVisibility => IsSaving ? Visibility.Visible : Visibility.Collapsed;


        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private string _tournamentName;
        public string TournamentName
        {
            get => _tournamentName;
            set
            {
                if (_tournamentName != value)
                {
                    _tournamentName = value;
                    OnPropertyChanged(nameof(TournamentName));
                }
            }
        }

        private int _level;
        public int Level
        {
            get => _level;
            set
            {
                if (_level != value)
                {
                    _level = value;
                    OnPropertyChanged(nameof(Level));
                }
            }
        }

        private int _totalEntries;
        public int TotalEntries
        {
            get => _totalEntries;
            set
            {
                if (_totalEntries != value)
                {
                    _totalEntries = value;
                    OnPropertyChanged(nameof(TotalEntries));
                }
            }
        }

        private int? _participantsRemaining = 0;
        public int? ParticipantsRemaining
        {
            get => _participantsRemaining;
            set
            {
                if (_participantsRemaining != value)
                {
                    _participantsRemaining = value;
                    OnPropertyChanged(nameof(ParticipantsRemaining));
                }
            }
        }

        private int? _totalRebuys = 0;
        public int? TotalRebuys
        {
            get => _totalRebuys;
            set
            {
                if (_totalRebuys != value)
                {
                    _totalRebuys = value;
                    OnPropertyChanged(nameof(TotalRebuys));
                }
            }
        }

        private int? _countRebuys = 0;
        public int? CountRebuys
        {
            get => _countRebuys;
            set
            {
                if (_countRebuys != value)
                {
                    _countRebuys = value;
                    OnPropertyChanged(nameof(CountRebuys));
                }
            }
        }

        private int? _totalInscriptions = 0;
        public int? TotalInscriptions
        {
            get => _totalInscriptions;
            set
            {
                if (_totalInscriptions != value)
                {
                    _totalInscriptions = value;
                    OnPropertyChanged(nameof(TotalInscriptions));
                }
            }
        }

        private int? _countInscriptions = 0;
        public int? CountInscriptions
        {
            get => _countInscriptions;
            set
            {
                if (_countInscriptions != value)
                {
                    _countInscriptions = value;
                    OnPropertyChanged(nameof(CountInscriptions));
                }
            }
        }

        private decimal? _averageChips = 0;
        public decimal? AverageChips
        {
            get => _averageChips;
            set
            {
                if (_averageChips != value)
                {
                    _averageChips = value;
                    OnPropertyChanged(nameof(AverageChips));
                }
            }
        }

        private DateTime _fechaInicio = DateTime.Now;
        public DateTime FechaInicio
        {
            get => _fechaInicio;
            set
            {
                if (_fechaInicio != value)
                {
                    _fechaInicio = value;
                    OnPropertyChanged(nameof(FechaInicio));
                }
            }
        }

        private decimal? _prizePool = 0;
        public decimal? PrizePool
        {
            get => _prizePool;
            set
            {
                if (_prizePool != value)
                {
                    _prizePool = value;
                    OnPropertyChanged(nameof(PrizePool));
                }
            }
        }

        private int _totalAddOn;
        public int TotalAddOn
        {
            get => _totalAddOn;
            set
            {
                if (_totalAddOn != value)
                {
                    _totalAddOn = value;
                    OnPropertyChanged(nameof(TotalAddOn));
                }
            }
        }

        private int _countAddOn;
        public int CountAddOn
        {
            get => _countAddOn;
            set
            {
                if (_countAddOn != value)
                {
                    _countAddOn = value;
                    OnPropertyChanged(nameof(CountAddOn));
                }
            }
        }

        private string _durationString;
        public string DurationString
        {
            get => _durationString;
            set
            {
                if (_durationString != value)
                {
                    _durationString = value;
                    OnPropertyChanged(nameof(DurationString));
                }
            }
        }

        public CreateTournamentViewModel(NotificationContainer notificationContainer)
        {

            AlertServices = new AlertServices(notificationContainer);

            _tournamentService = new TournamentService();

            Levels = new ObservableCollection<BlindLevel>();

            SaveCommand = new RelayCommand(SaveTournament);
            CancelCommand = new RelayCommand(Cancel);
            AddNewLevelCommand = new RelayCommand(AddNewLevel);
            AddBreakCommand = new RelayCommand(AddBreak);
            DeleteLevelCommand = new RelayCommand<BlindLevel>(DeleteLevel);
        }

        private async void SaveTournament()
        {
            if (TournamentName.IsNullOrEmpty())
            {
                NombreTorneoNullo();
                return;
            }

            try
            {
                IsSaving = true;

                await Task.Run(() =>
                {
                    foreach (var lvl in Levels)
                    {
                        lvl.ConvertDurationToTimeSpan();
                    }

                    var tournament = new Tournament
                    {
                        TournamentName = TournamentName,
                        Level = Level,
                        TotalEntries = TotalEntries,
                        ParticipantsRemaining = ParticipantsRemaining,
                        TotalRebuys = TotalRebuys,
                        CountRebuys = CountRebuys,
                        TotalInscriptions = TotalInscriptions,
                        CountInscriptions = CountInscriptions,
                        AverageChips = AverageChips,
                        PrizePool = PrizePool,
                        TotalAddOn = TotalAddOn,
                        CountAddOn = CountAddOn,
                        FechaInicio = FechaInicio,
                        Levels = new List<BlindLevel>(Levels)
                    };

                    _tournamentService.SaveOrUpdateTournament(tournament);
                });


                var tournamentHome = new TournamentHomeView();
                tournamentHome.Show();

                var currentWindow = Application.Current.Windows.OfType<CreateTournamentView>().FirstOrDefault();
                currentWindow?.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"An error occurred while saving the tournament: {ex.Message}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            finally
            {
                IsSaving = false;
            }
        }

        private void Cancel()
        {
            Application.Current.MainWindow.Close();
        }

        private void AddNewLevel()
        {
            int nextLevel = Levels.Count(l => l.BlindType == BlindTypeEnum.Level) + 1;

            Levels.Add(new BlindLevel
            {
                Level = nextLevel,
                SmallBlind = 0,
                BigBlind = 0,
                Ante = 0,
                DurationString = "10 min",
                BlindType = BlindTypeEnum.Level
            });
        }

        private void AddBreak()
        {
            Levels.Add(new BlindLevel
            {
                Level = null,
                SmallBlind = 0,
                BigBlind = 0,
                Ante = 0,
                DurationString = "1",
                BlindType = BlindTypeEnum.Break
            });
        }

        private void DeleteLevel(BlindLevel level)
        {
            if (level != null)
            {
                Levels.Remove(level);

                int levelCounter = 1;
                foreach (var lvl in Levels.Where(l => l.BlindType == BlindTypeEnum.Level))
                {
                    lvl.Level = levelCounter++;
                }
            }
        }

        public void NombreTorneoNullo()
        {
            AlertServices.SendWarning("Tournament Name", "El nombre del torneo no puede ser nulo");
        }
    }
}
