﻿using holdemmanager_backend_web.Domain.Models;

namespace holdemmanager_backend_web.Domain.IServices
{
    public interface ILoginServiceWeb
    {
        Task<UsuarioWeb> ValidateUser(UsuarioWeb usuario);
    }
}
