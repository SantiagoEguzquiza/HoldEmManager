using Flattinger.UI.ToastMessage.Controls;
using holdemmanager_reloj.Helpers;
using holdemmanager_reloj.Models;
using holdemmanager_reloj.Services;
using holdemmanager_reloj.ViewModels;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Forms;
using System.Windows.Input;

namespace holdemmanager_reloj.Views
{
    /// <summary>
    /// Lógica de interacción para TournamentList.xaml
    /// </summary>
    public partial class TournamentListView : Window
    {
        private static TournamentListView _instance;
        private static readonly object _lock = new object();

        private AlertServices _alertServices;
        private TournamentListViewModel _viewModel;
        private TournamentService _tournamentService;

        public TournamentListView()
        {
            InitializeComponent();

            _alertServices = new AlertServices(notificationContainer);
            _viewModel = new TournamentListViewModel(notificationContainer);
            _tournamentService = new TournamentService();

            this.DataContext = _viewModel;
        }

        public static TournamentListView Instance
        {
            get
            {
                lock (_lock)
                {
                    if (_instance == null)
                    {
                        _instance = new TournamentListView();
                    }
                    return _instance;
                }
            }
        }

        private void BackBtn_Click(object sender, RoutedEventArgs e)
        {
            TournamentHomeView tournamentHome = new TournamentHomeView();
            tournamentHome.Show();
            Close();
        }

        private void CloseBtn_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void DockPanel_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (e.ChangedButton == MouseButton.Left)
                this.DragMove();
        }

        private void PlayTournament_Click(object sender, RoutedEventArgs e)
        {
            
            var tournament = (sender as System.Windows.Controls.Button).DataContext as Tournament;
            _viewModel.PlayTournament(tournament);
            Close();
        }
    }
}