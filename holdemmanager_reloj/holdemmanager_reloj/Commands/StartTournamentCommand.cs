using holdemmanager_reloj.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace holdemmanager_reloj.Commands
{
    public class StartTournamentCommand : ICommand
    {
        private readonly BlindClockService _blindClockService;

        public StartTournamentCommand(BlindClockService blindClockService)
        {
            _blindClockService = blindClockService;
        }

        public event EventHandler CanExecuteChanged;

        public bool CanExecute(object parameter)
        {
            return true;
        }

        public void Execute(object parameter)
        {
            //_blindClockService.Start();
        }
    }
}
