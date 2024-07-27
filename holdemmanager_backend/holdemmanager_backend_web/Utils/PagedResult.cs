using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Utils
{
    public class PagedResult<T>
    {
        public List<T> Items { get; set; }
        public bool HasNextPage { get; set; }
    }
}
