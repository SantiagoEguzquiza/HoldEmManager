using holdemmanager_reloj.ViewModels;
using System.Windows;
using System.Windows.Input;

namespace holdemmanager_reloj.Views
{
    /// <summary>
    /// Lógica de interacción para BlindClockView.xaml
    /// </summary>
    public partial class BlindClockView : Window
    {
        private BlindClockViewModel _viewModel;

        public BlindClockView()
        {
            InitializeComponent();
            this.PreviewKeyDown += new KeyEventHandler(HandleKeyPress);

            _viewModel = new BlindClockViewModel();

            this.DataContext = _viewModel;

            _viewModel.StartCommand.Execute(null);
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
        }

        private void GoFullScreen()
        {
            this.WindowStyle = WindowStyle.None;
            this.WindowState = WindowState.Normal;
            this.WindowState = WindowState.Maximized;
            this.ResizeMode = ResizeMode.NoResize;
            this.Topmost = true;
        }
    }
}

