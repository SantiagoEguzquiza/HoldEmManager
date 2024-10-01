using Flattinger.UI.ToastMessage.Controls;
using holdemmanager_reloj.Models;
using holdemmanager_reloj.ViewModels;
using holdemmanager_reloj.Views;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace holdemmanager_reloj.Services
{
    public class NavigationService
    {
        public static void NavigateTo(string viewName, object parameter = null)
        {
            Window window = null;

            if (viewName == "EditTournamentView" && parameter is Tournament tournament)
            {
                window =  EditTournamentView.ObtenerInstancia(tournament);
            }
            else if (viewName == "BlindClockView" && parameter is Tournament tournamentPlay)
            {
                 window = BlindClockView.ObtenerInstancia(tournamentPlay);

            }
            else
            {
                var windowType = Type.GetType($"holdemmanager_reloj.Views.{viewName}");
                if (windowType != null)
                {
                    window = Activator.CreateInstance(windowType) as Window;
                }
            }

            if (window != null)
            {
                window.Show();
            }
            else
            {
                MessageBox.Show($"No se pudo crear la ventana: {viewName}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public static void CloseCurrentWindow()
        {
            var currentWindow = Application.Current.Windows.OfType<Window>().SingleOrDefault(w => w.IsActive);
            currentWindow?.Close();
        }
    }
}
