namespace holdemmanager_backend_app.Utils
{
    public class PagedResult<T>
    {
        public List<T> Items { get; set; }
        public bool HasNextPage { get; set; }
    }
}
