using Firebase.Auth;
using Firebase.Storage;
using Newtonsoft.Json.Linq;

namespace holdemmanager_backend_app.Utils
{
    public class FirebaseStorageHelper
    {
        private static readonly HttpClient httpClient = new HttpClient();
        private string api_key = "AIzaSyAWV4QN7q9590HmcMQymlxmDp6-PZg1Brw";
        private string email = "holdemmanager@gmail.com";
        private string clave = "holdemmanager123";
        private string ruta = "holdemmanager-16a40.appspot.com";

        public async Task<string> SubirStorage(Stream imagen)
        {
            var auth = new FirebaseAuthProvider(new FirebaseConfig(api_key));
            var a = await auth.SignInWithEmailAndPasswordAsync(email, clave);

            var cancellation = new CancellationTokenSource();

            string uniqueFileName = $"{Guid.NewGuid()}.jpg";

            var task = new FirebaseStorage(
                ruta,
                new FirebaseStorageOptions
                {
                    AuthTokenAsyncFactory = () => Task.FromResult(a.FirebaseToken),
                    ThrowOnCancel = true
                })
                .Child("Prensa_Img")
                 .Child(uniqueFileName)
                .PutAsync(imagen, cancellation.Token);

            var downloadURL = await task;

            return downloadURL;
        }

        public async Task EliminarImagen(string imageUrl)
        {
            var auth = new FirebaseAuthProvider(new FirebaseConfig(api_key));
            var a = await auth.SignInWithEmailAndPasswordAsync(email, clave);

            var firebaseStorage = new FirebaseStorage(
                ruta,
                new FirebaseStorageOptions
                {
                    AuthTokenAsyncFactory = () => Task.FromResult(a.FirebaseToken),
                    ThrowOnCancel = true
                });

            var uri = new Uri(imageUrl);
            var fileName = Path.GetFileName(uri.LocalPath);

            await firebaseStorage
                .Child("Prensa_Img")
                .Child(fileName)
                .DeleteAsync();
        }
    }
}