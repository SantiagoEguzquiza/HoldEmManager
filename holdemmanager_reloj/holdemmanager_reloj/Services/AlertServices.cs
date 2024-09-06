using Flattinger.Core.Enums;
using Flattinger.Core.Interface.ToastMessage;
using Flattinger.UI.ToastMessage.Controls;
using Flattinger.UI.ToastMessage;
using Flattinger.Core.Theme;

namespace holdemmanager_reloj.Services
{
    public class AlertServices
    {
        private readonly NotificationContainer _notificationContainer;
        private readonly AppTheme _appTheme;
        private readonly ToastProvider _toastProvider;

        public AlertServices(NotificationContainer notificationContainer)
        {
            _notificationContainer = notificationContainer;
            _toastProvider = new ToastProvider(_notificationContainer); 
            _appTheme = new AppTheme();
            _appTheme.ChangeTheme(Flattinger.Core.Enums.Theme.DARK);
        }

        private void SendAlert(ToastType toastType, string title, string message)
        {
            _toastProvider.NotificationService.AddNotification(toastType, title, message, 5, animationConfig: new AnimationConfig { });
        }

        public void SendWarning(string title, string message)
        {
            SendAlert(ToastType.WARNING, title, message);
        }

        public void SendError(string title, string message)
        {
            SendAlert(ToastType.ERROR, title, message);
        }

        public void SendInfo(string title, string message)
        {
            SendAlert(ToastType.INFO, title, message);
        }

        public void SendSuccess(string title, string message)
        {
            SendAlert(ToastType.SUCCESS, title, message);
        }
    }
}
