using holdemmanager_reloj.Models;
using holdemmanager_reloj.ViewModels;
using System.Windows;
using System.Windows.Input;

namespace holdemmanager_reloj.Views
{
    public partial class BlindClockView : Window
    {
        // Instancia única de la clase
        private static BlindClockView instanciaUnica = null;

        // Objeto para bloqueo de hilo
        private static readonly object bloqueo = new object();

        // Constructor privado para evitar la creación de instancias
        public BlindClockView(Tournament tournament)
        {
            InitializeComponent();
            this.PreviewKeyDown += new KeyEventHandler(HandleKeyPress);

            this.DataContext = new BlindClockViewModel(tournament);
        }

        // Método estático público para obtener la instancia única
        public static BlindClockView ObtenerInstancia(Tournament tournament)
        {
            // Doble verificación de bloqueo para asegurar que solo una instancia sea creada
            if (instanciaUnica == null)
            {
                lock (bloqueo)
                {
                    if (instanciaUnica == null)
                    {
                        instanciaUnica = new BlindClockView(tournament);
                    }
                }
            }
            return instanciaUnica;
        }

        private void HandleKeyPress(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Escape)
            {
                if (this.WindowStyle == WindowStyle.None)
                {
                    this.WindowStyle = WindowStyle.SingleBorderWindow;
                    this.WindowState = WindowState.Maximized;
                    this.ResizeMode = ResizeMode.CanResize;
                    this.Topmost = false;
                }
            }
            else if (e.Key == Key.F11)
            {
                GoFullScreen();
            }
            else if (e.Key == Key.Space)
            {
                ReaundarStopTiming();
            }
            else if (e.Key == Key.X)
            {
                RestarJugador();
            }
        }

        private void GoFullScreen()
        {
            this.WindowStyle = WindowStyle.None;
            this.WindowState = WindowState.Normal;
            this.WindowState = WindowState.Maximized;
            this.ResizeMode = ResizeMode.NoResize;
            this.Topmost = true;
        }

        private void ReaundarStopTiming()
        {
            if (this.DataContext is BlindClockViewModel viewModel)
            {
                viewModel.PauseCommand.Execute(null);
            }
        }

        private void RestarJugador()
        {
            if (this.DataContext is BlindClockViewModel viewModel)
            {
                viewModel.ToSubtractPlayer.Execute(null);
            }
        }
    }
}
