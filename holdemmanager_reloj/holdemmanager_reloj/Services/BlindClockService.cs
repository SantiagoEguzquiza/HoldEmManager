using holdemmanager_reloj.Models;
using System.Timers;

namespace holdemmanager_reloj.Services
{
    public class BlindClockService
    { 
        public BlindLevel GetNextLevel(Tournament tournament, BlindLevel currentLevel)
        {
            if (tournament.Levels == null || currentLevel == null)
                return null;

            int currentIndex = tournament.Levels.Select((level, index) => new { level, index })
                                                .FirstOrDefault(x => x.level == currentLevel)?.index ?? -1;

            if (currentIndex >= 0 && currentIndex < tournament.Levels.Count - 1)
            {
                var nextLevel = tournament.Levels.ElementAt(currentIndex + 1);

                    return nextLevel;
            }

            return null;
        }

        public TimeSpan GetNextBreakTiming(Tournament tournament, BlindLevel currentLevel)
        {
            var timingToBreak = TimeSpan.Zero;

            if (tournament.Levels == null || currentLevel == null)
                return timingToBreak;

            int currentIndex = tournament.Levels.Select((level, index) => new { level, index })
                                                .FirstOrDefault(x => x.level == currentLevel)?.index ?? -1;

            if (currentIndex >= 0)
            {
                var nextBreak = tournament.Levels.Skip(currentIndex + 1)
                                                 .FirstOrDefault(level => level.BlindType == BlindTypeEnum.Break);

                if (nextBreak != null)
                {
                    foreach (var level in tournament.Levels.Skip(currentIndex))
                    {
                        if (level == nextBreak) break;
                        timingToBreak += level.Duration;
                    }

                    return timingToBreak;
                }
            }

            return timingToBreak;
        }
    }
}
