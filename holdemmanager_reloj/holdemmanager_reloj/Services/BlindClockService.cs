using holdemmanager_reloj.Models;
using System.Timers;

namespace holdemmanager_reloj.Services
{
    public class BlindClockService
    {
        private System.Timers.Timer _timer;
        private TimeSpan _remainingTime;
        private Tournament _tournament;

        public event Action<string> OnClockTick;
        public event Action<BlindLevel> OnLevelChange;
        public event Action<TimeSpan> OnBreakTimeUpdate;

        public BlindClockService(Tournament tournament)
        {
            _tournament = tournament;
            _remainingTime = new TimeSpan(0, 30, 0);
        }

        public void Start()
        {
            _timer = new System.Timers.Timer(1000);
            _timer.Elapsed += TimerElapsed;
            _timer.Start();
        }

        public void Stop()
        {
            _timer?.Stop();
        }

        private void TimerElapsed(object sender, ElapsedEventArgs e)
        {
            _remainingTime = _remainingTime.Subtract(TimeSpan.FromSeconds(1));

            OnClockTick?.Invoke(_remainingTime.ToString(@"mm\:ss"));

            if (_remainingTime.TotalSeconds <= 0)
            {
                AdvanceToNextLevel();
            }

            OnBreakTimeUpdate?.Invoke(_tournament.TimeRemainingForNextBreak.Subtract(TimeSpan.FromSeconds(1)));
        }

        private void AdvanceToNextLevel()
        {
            _timer.Stop();

            _tournament.Level++;
            _tournament.CurrentBlindLevel = _tournament.NextBlindLevel;

            _tournament.NextBlindLevel = new BlindLevel
            {
                SmallBlind = _tournament.CurrentBlindLevel.SmallBlind * 2,
                BigBlind = _tournament.CurrentBlindLevel.BigBlind * 2,
                Ante = _tournament.CurrentBlindLevel.Ante * 2
            };

            OnLevelChange?.Invoke(_tournament.CurrentBlindLevel);

            _remainingTime = new TimeSpan(0, 30, 0);
            _timer.Start();
        }
    }
}
