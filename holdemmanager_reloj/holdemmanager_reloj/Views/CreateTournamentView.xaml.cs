using Flattinger.UI.ToastMessage.Controls;
using holdemmanager_reloj.ViewModels;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace holdemmanager_reloj.Views
{
    /// <summary>
    /// Lógica de interacción para CreateEditTournament.xaml
    /// </summary>
    public partial class CreateTournamentView : Window
    {
        public CreateTournamentView()
        {
            InitializeComponent();
            DataContext = new CreateTournamentViewModel(new NotificationContainer());
        }

        private void DurationTextBox_LostFocus(object sender, RoutedEventArgs e)
        {
            if (sender is TextBox textBox)
            {
                string duration = textBox.Text?.Trim() ?? string.Empty;

                if (string.IsNullOrWhiteSpace(duration))
                {
                    textBox.Text = "1 min";
                }
                else if (!duration.EndsWith("min", StringComparison.OrdinalIgnoreCase))
                {
                    textBox.Text = $"{duration.Split(' ')[0]} min";
                }
            }
        }

        private void DockPanel_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (e.ChangedButton == MouseButton.Left)
                this.DragMove();
        }

        private void CloseBtn_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void BackBtn_Click(object sender, RoutedEventArgs e)
        {
            TournamentHomeView tournamentHome = new TournamentHomeView();
            tournamentHome.Show();
            Close();
        }

        private void TextBox_LostFocus(object sender, RoutedEventArgs e)
        {
            if (sender is TextBox textBox)
            {
                if (string.IsNullOrWhiteSpace(textBox.Text))
                {
                    textBox.Text = "0";
                }
            }
        }

        public void CloseWindow()
        {
            this.Close();
        }
    }
}
