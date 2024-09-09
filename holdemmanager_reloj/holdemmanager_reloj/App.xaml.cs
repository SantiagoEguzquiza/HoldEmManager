using holdemmanager_reloj.Views;
using Microsoft.Extensions.Configuration;
using System.Configuration;
using System.Data;
using System.IO;
using System.Windows;

namespace holdemmanager_reloj
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {

        public static IConfiguration Configuration { get; private set; }

        public App()
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);

            Configuration = builder.Build();
        }
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            TournamentHomeView tournamentHome = new TournamentHomeView();
            tournamentHome.Show();
        }
    }
}
