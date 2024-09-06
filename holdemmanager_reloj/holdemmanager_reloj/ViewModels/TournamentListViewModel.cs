using Flattinger.UI.ToastMessage.Controls;
using holdemmanager_reloj.Commands;
using holdemmanager_reloj.Helpers;
using holdemmanager_reloj.Models;
using holdemmanager_reloj.Services;
using holdemmanager_reloj.Views;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows;
using System.Windows.Input;

namespace holdemmanager_reloj.ViewModels
{
    public class TournamentListViewModel : INotifyPropertyChanged
    {
        private readonly AlertServices _alertServices;

        public ObservableCollection<Tournament> Tournaments { get; set; }
        private readonly TournamentService _tournamentService;
        public ICommand EditCommand { get; private set; }
        public ICommand DeleteCommand { get; private set; }
        public ICommand PlayCommand { get; private set; }

        public TournamentListViewModel(NotificationContainer notificationContainer)
        {
            EditCommand = new RelayCommand<Tournament>(EditTournament);
            DeleteCommand = new RelayCommand<Tournament>(DeleteTournament);
            PlayCommand = new RelayCommand<Tournament>(PlayTournament);

            _tournamentService = new TournamentService();

            Tournaments = new ObservableCollection<Tournament>();

            _alertServices = new AlertServices(notificationContainer);

            _ = LoadTournamentsAsync();
        }

        private void DeleteTournament(Tournament tournament)
        {
            if (tournament != null)
            {
                var confirmationDialog = new ConfirmationDialog("¿Estás seguro de que deseas eliminar este torneo?");
                confirmationDialog.ShowDialog();

                if (confirmationDialog.IsConfirmed)
                {
                    try
                    {
                        _tournamentService.DeleteLevelsByTournamentId(tournament.TournamentId);

                        _tournamentService.DeleteTournament(tournament);

                        Tournaments.Remove(tournament);

                        _alertServices.SendSuccess("Torneo eliminado", "El torneo ha sido eliminado exitosamente.");

                    }
                    catch (Exception ex)
                    {
                    }
                }
            }
        }

        private async Task LoadTournamentsAsync()
        {
            Tournaments.Clear();

            var tournaments = await _tournamentService.ListTournamentAsync();

            foreach (var tournament in tournaments)
            {
                Tournaments.Add(tournament);
            }
        }

        private void EditTournament(Tournament selectedTournament)
        {
            if (selectedTournament != null)
            {

                var currentWindow = Application.Current.Windows.OfType<Window>().SingleOrDefault(x => x.IsActive);

                NavigationService.NavigateTo("EditTournamentView", selectedTournament);

                if (currentWindow != null)
                {
                    currentWindow.Close();
                }
            }
        }

        private void PlayTournament(Tournament selectedTournament)
        {
            if (selectedTournament != null)
            {
                NavigationService.NavigateTo("BlindClockView", selectedTournament);
                NavigationService.NavigateTo("EditTournamentView", selectedTournament);

            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}