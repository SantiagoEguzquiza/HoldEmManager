using Flattinger.UI.ToastMessage.Controls;
using holdemmanager_reloj.Commands;
using holdemmanager_reloj.Models;
using holdemmanager_reloj.Services;
using System.Windows.Input;
using System.Windows;
using System.ComponentModel;
using System.Windows.Threading;
using holdemmanager_reloj.Views;

namespace holdemmanager_reloj.ViewModels
{
    public class EditTournamentViewModel : INotifyPropertyChanged
    {

        private AlertServices AlertServices;

        private Tournament _tournament = new Tournament();
        public Tournament Tournament
        {
            get => _tournament;
            set
            {
                _tournament = value;
                OnPropertyChanged(nameof(Tournament));
            }
        }

        private Visibility _isLoadingVisible = Visibility.Collapsed;
        public Visibility IsLoadingVisible
        {
            get => _isLoadingVisible;
            set
            {
                _isLoadingVisible = value;
                OnPropertyChanged(nameof(IsLoadingVisible));
            }
        }

        private bool _canSave;
        public bool CanSave
        {
            get => _canSave;
            set
            {
                _canSave = value;
                OnPropertyChanged(nameof(CanSave));
            }
        }

        private readonly TournamentService _tournamentService;

        public event PropertyChangedEventHandler? PropertyChanged;

        public ICommand SaveCommand { get; }
        public ICommand CancelCommand { get; }
        public ICommand AddNewLevelCommand { get; }
        public ICommand AddBreakCommand { get; }
        public ICommand DeleteLevelCommand { get; }
        public ICommand SendTestNotification { get; }

        public EditTournamentViewModel(NotificationContainer notificationContainer, Tournament tournament)
        {
            StartEnableSaveButtonTimer();

            AlertServices = new AlertServices(notificationContainer);


            _tournamentService = new TournamentService();

            Tournament = tournament ?? new Tournament();

            foreach (var lvl in Tournament.Levels)
            {
                lvl.ConvertTimeSpanToDurationString();
            }
            SaveCommand = new RelayCommand(SaveTournamentAsync);
            CancelCommand = new RelayCommand(Cancel);
            AddNewLevelCommand = new RelayCommand(AddNewLevel);
            AddBreakCommand = new RelayCommand(AddBreak);
            DeleteLevelCommand = new RelayCommand<BlindLevel>(DeleteLevel);
        }

        

        private void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        public bool ValidateTournamentName()
        {
            return !string.IsNullOrWhiteSpace(Tournament.TournamentName);
        }

        private void StartEnableSaveButtonTimer()
        {
            DispatcherTimer timer = new DispatcherTimer();
            timer.Interval = TimeSpan.FromSeconds(5);
            timer.Tick += (sender, args) =>
            {
                CanSave = true;
                timer.Stop();
            };
            timer.Start();
        }

        public async void SaveTournamentAsync()
        {
            IsLoadingVisible = Visibility.Visible;

            try
            {
                foreach (var lvl in Tournament.Levels)
                {
                    lvl.ConvertDurationToTimeSpan();
                }

                var updatedLevels = new List<BlindLevel>();
                var newLevels = new List<BlindLevel>();
                var deletedLevels = new List<BlindLevel>();

                var existingLevels = await Task.Run(() => _tournamentService.GetLevelsByTournamentId(Tournament.TournamentId));

                deletedLevels = existingLevels
                    .Where(existingLevel => !Tournament.Levels.Any(level => level.BlindLevelId == existingLevel.BlindLevelId))
                    .ToList();

                foreach (var level in Tournament.Levels)
                {
                    if (level.BlindLevelId == 0)
                    {
                        newLevels.Add(level);
                    }
                    else
                    {
                        updatedLevels.Add(level);
                    }
                }

                await Task.Run(() =>
                {
                    foreach (var level in deletedLevels)
                    {
                        _tournamentService.DeleteLevel(level);
                    }

                    if (updatedLevels.Count > 0)
                    {
                        _tournamentService.UpdateLevels(updatedLevels);
                    }

                    foreach (var newLevel in newLevels)
                    {
                        _tournamentService.AddNewLevel(newLevel);
                    }

                    _tournamentService.SaveOrUpdateTournament(Tournament);
                });

                TournamentListView tournamentListView =  TournamentListView.Instance;
                tournamentListView.Show();

                Application.Current.Dispatcher.Invoke(() => {
                    foreach (Window window in Application.Current.Windows)
                    {
                        if (window is EditTournamentView)
                        {
                            window.Close();
                            break;
                        }
                    }
                });

            }
            catch (Exception ex)
            {
                AlertServices.SendError($"An error occurred while saving the tournament: {ex.Message}", "Error");
            }
            finally
            {
                IsLoadingVisible = Visibility.Collapsed;
            }
        }

        private void Cancel()
        {
            Application.Current.MainWindow.Close();
        }

        private void AddNewLevel()
        {
            int nextLevel = Tournament.Levels.Count(l => l.BlindType == BlindTypeEnum.Level) + 1;

            var newLevel = new BlindLevel
            {
                Level = nextLevel,
                SmallBlind = 0,
                BigBlind = 0,
                Ante = 0,
                DurationString = "10 min",
                BlindType = BlindTypeEnum.Level,
                TournamentId = Tournament.TournamentId
            };

            Tournament.Levels.Add(newLevel);

        }

        private void AddBreak()
        {
            var newLevel = new BlindLevel
            {
                Level = null,
                SmallBlind = 0,
                BigBlind = 0,
                Ante = 0,
                DurationString = "1",
                BlindType = BlindTypeEnum.Break,
                TournamentId = Tournament.TournamentId
            };

            Tournament.Levels.Add(newLevel);

        }

        private void DeleteLevel(BlindLevel level)
        {
            if (level != null)
            {
                Tournament.Levels.Remove(level);

                int levelCounter = 1;
                foreach (var lvl in Tournament.Levels.Where(l => l.BlindType == BlindTypeEnum.Level))
                {
                    lvl.Level = levelCounter++;
                }
            }
        }
    }
}
