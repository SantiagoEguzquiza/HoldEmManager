using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Domain.Excepciones
{
    public class RecursoNoEncontradoException : Exception
    {
        public RecursoNoEncontradoException (string message) : base(message) { }
    }

}
