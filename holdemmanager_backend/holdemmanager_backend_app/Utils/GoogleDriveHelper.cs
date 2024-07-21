using Google.Apis.Auth.OAuth2;
using Google.Apis.Drive.v3;
using Google.Apis.Services;

namespace holdemmanager_backend_app.Utils
{
    public class GoogleDriveHelper
    {
        static string[] Scopes = { DriveService.Scope.Drive, DriveService.Scope.DriveFile };
        static string ApplicationName = "HoldemManager";
        static string folderId = "1efsRPwvTsoU9R5M9G3zjGiKru3xvlKMr";

        private readonly DriveService _service;

        public GoogleDriveHelper()
        {
            string credentialsPath = "credentials.json";

            GoogleCredential credential;
            using (var stream = new FileStream(credentialsPath, FileMode.Open, FileAccess.Read))
            {
                credential = GoogleCredential.FromStream(stream).CreateScoped(Scopes);
            }

            _service = new DriveService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = ApplicationName
            });
        }

        public async Task<string> UploadFileAsync(string filePath)
        {
            var fileMetaData = new Google.Apis.Drive.v3.Data.File()
            {
                Name = Path.GetFileName(filePath),
                Parents = new List<string> { folderId }
            };

            FilesResource.CreateMediaUpload request;
            using (var stream = new FileStream(filePath, FileMode.Open))
            {
                request = _service.Files.Create(fileMetaData, stream, "image/jpeg");
                request.Fields = "id";
                await request.UploadAsync();
            }

            var uploadedFile = request.ResponseBody;
            return uploadedFile.Id;
        }
    }
}
