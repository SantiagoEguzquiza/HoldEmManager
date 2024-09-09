using holdemmanager_reloj.Helpers;
using holdemmanager_reloj.Models;
using holdemmanager_reloj.Services;
using holdemmanager_reloj.ViewModels;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace holdemmanager_reloj.Views
{
    /// <summary>
    /// Lógica de interacción para TournamentList.xaml
    /// </summary>
    public partial class TournamentListView : Window
    {
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
    }
}
