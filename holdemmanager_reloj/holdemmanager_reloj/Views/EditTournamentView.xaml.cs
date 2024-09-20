using Flattinger.UI.ToastMessage.Controls;
using holdemmanager_reloj.Models;
using holdemmanager_reloj.Services;
using holdemmanager_reloj.ViewModels;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace holdemmanager_reloj.Views
{
    /// <summary>
    /// Lógica de interacción para TournamentInfoView.xaml
    /// </summary>
    public partial class EditTournamentView : Window
    {
        private AlertServices alertServices;
        private EditTournamentViewModel viewModel;

        // Instancia única de la clase
        private static EditTournamentView instanciaUnica = null;

        // Objeto para bloqueo de hilo
        private static readonly object bloqueo = new object();

        // Constructor privado para evitar la creación de instancias
        private EditTournamentView(Tournament tournament)
        {
            InitializeComponent();

            viewModel = new EditTournamentViewModel(new NotificationContainer(), tournament);
            DataContext = viewModel;

            alertServices = new AlertServices(notificationContainer);
        }

        // Método estático público para obtener la instancia única
        public static EditTournamentView ObtenerInstancia(Tournament tournament)
        {
            // Doble verificación de bloqueo para asegurar que solo una instancia sea creada
            if (instanciaUnica == null)
            {
                lock (bloqueo)
                {
                    if (instanciaUnica == null)
                    {
                        instanciaUnica = new EditTournamentView(tournament);
                    }
                }
            }
            return instanciaUnica;
        }

        private void DurationTextBox_LostFocus(object sender, RoutedEventArgs e)
        {
            var textBox = sender as TextBox;
            if (textBox != null)
            {
                if (!Regex.IsMatch(textBox.Text, @"^\d{1,2} min( break)?$"))
                {
                    textBox.Text = "10 min";

                    alertServices.SendWarning("Formato Incorrecto", "El formato de la duración es inválido. Se ha restablecido a '10 min'.");

                    textBox.Focus();
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
            TournamentListView tournamentHome = new TournamentListView();
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

        private void SaveTournamentAsync(object sender, RoutedEventArgs e)
        {
            if (viewModel != null && !viewModel.ValidateTournamentName())
            {
                alertServices.SendWarning("Campo Requerido", "El nombre del torneo no puede estar vacío.");
                return;
            }

            viewModel.SaveTournamentAsync();
        }
    }
}
