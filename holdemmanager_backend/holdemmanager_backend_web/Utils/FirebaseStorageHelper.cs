using Firebase.Auth;
using Firebase.Storage;
using Microsoft.Extensions.Configuration;

namespace holdemmanager_backend_app.Utils
{
    public class FirebaseStorageHelper
    {
        private readonly string apiKey;
        private readonly string email;
        private readonly string password;
        private readonly string storageBucket;

        public FirebaseStorageHelper(IConfiguration configuration)
        {
            apiKey = configuration["Firebase:ApiKey"];
            email = configuration["Firebase:Email"];
            password = configuration["Firebase:Password"];
            storageBucket = configuration["Firebase:StorageBucket"];
        }

        public async Task<string> SubirImagenFirebase(Stream imagen, string directorio)
        {
            var auth = new FirebaseAuthProvider(new FirebaseConfig(apiKey));
            var a = await auth.SignInWithEmailAndPasswordAsync(email, password);

            var cancellation = new CancellationTokenSource();

            string uniqueFileName = $"{Guid.NewGuid()}.jpg";

            var task = new FirebaseStorage(
                storageBucket,
                new FirebaseStorageOptions
                {
                    AuthTokenAsyncFactory = () => Task.FromResult(a.FirebaseToken),
                    ThrowOnCancel = true
                })
                .Child(directorio)
                .Child(uniqueFileName)
                .PutAsync(imagen, cancellation.Token);

            var downloadURL = await task;

            return downloadURL;
        }

        public async Task<string> SubirStorageRecurso(Stream imagen)
        {
            return await SubirImagenFirebase(imagen, "Recurso_Img");
        }

        public async Task<string> SubirStorageNoticia(Stream imagen)
        {
            return await SubirImagenFirebase(imagen, "Noticia_Img");
        }

        public async Task EliminarImagen(string imageUrl, string directorio)
        {
            var auth = new FirebaseAuthProvider(new FirebaseConfig(apiKey));
            var a = await auth.SignInWithEmailAndPasswordAsync(email, password);

            var firebaseStorage = new FirebaseStorage(
                storageBucket,
                new FirebaseStorageOptions
                {
                    AuthTokenAsyncFactory = () => Task.FromResult(a.FirebaseToken),
                    ThrowOnCancel = true
                });

            var uri = new Uri(imageUrl);
            var fileName = Path.GetFileName(uri.LocalPath);

            await firebaseStorage
                .Child(directorio)
                .Child(fileName)
                .DeleteAsync();
        }

        public async Task EliminarImagenNoticia(string imageUrl)
        {
            await EliminarImagen(imageUrl, "Noticia_Img");
        }

        public async Task EliminarImagenRecurso(string imageUrl)
        {
            await EliminarImagen(imageUrl, "Recurso_Img");
        }
    }
}