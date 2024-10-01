using holdemmanager_reloj.ViewModels;
using System.Windows;
using System.Windows.Input;
using System.Windows.Threading;

namespace holdemmanager_reloj.Views
{
    /// <summary>
    /// Lógica de interacción para TournamentAdministration.xaml
    /// </summary>
    public partial class TournamentHomeView : Window
    {
        public TournamentHomeView()
        {
            InitializeComponent();
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

        private async void Border1_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            LoadingGrid.Visibility = Visibility.Visible;

            await Dispatcher.Yield(DispatcherPriority.Background);

            TournamentListView tournamentList = null;
            TournamentListViewModel viewModel = null;

            tournamentList =  TournamentListView.Instance;
            var notificationContainer = tournamentList.notificationContainer;

            viewModel = new TournamentListViewModel(notificationContainer);
            tournamentList.DataContext = viewModel;

            tournamentList.Show();

            LoadingGrid.Visibility = Visibility.Collapsed;

            Close();
        }

        private async void Border2_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {

            CreateTournamentView createTournament = new CreateTournamentView();
            createTournament.Show();

            Close();
        }
    }
}
