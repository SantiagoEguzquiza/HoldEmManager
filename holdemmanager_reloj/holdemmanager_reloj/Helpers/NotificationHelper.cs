using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;

namespace holdemmanager_reloj.Helpers
{
    public class NotificationHelper
    {
        private readonly MediaPlayer _mediaPlayer;

        public NotificationHelper()
        {
            _mediaPlayer = new MediaPlayer();
        }

        public void PlaySound()
        {
            try
            {
                var uri = new Uri(@"Resources\message-alert.mp3", UriKind.RelativeOrAbsolute);

                _mediaPlayer.Open(uri);
                _mediaPlayer.MediaEnded += (s, e) => _mediaPlayer.Stop();
                _mediaPlayer.Play();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al reproducir el sonido: {ex.Message}");
            }
        }

        /// <summary>
        /// Detiene cualquier sonido que esté reproduciendo actualmente.
        /// </summary>
        public void StopSound()
        {
            _mediaPlayer.Stop();
        }
    }
}
