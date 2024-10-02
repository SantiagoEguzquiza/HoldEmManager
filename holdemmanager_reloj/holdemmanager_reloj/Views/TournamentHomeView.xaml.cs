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

            TournamentListView tournamentList = new TournamentListView();
            TournamentListViewModel viewModel = new TournamentListViewModel(tournamentList.notificationContainer);
            tournamentList.DataContext = viewModel;

            tournamentList.Show();

            LoadingGrid.Visibility = Visibility.Collapsed;

            // Cierra la ventana actual después de un pequeño retraso para asegurarse de que todas las operaciones se hayan completado
            await Task.Delay(100);
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
