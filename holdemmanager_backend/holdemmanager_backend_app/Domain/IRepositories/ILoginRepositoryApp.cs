﻿using holdemmanager_backend_app.Domain.Models;

namespace holdemmanager_backend_app.Domain.IRepositories
{
    public interface ILoginRepositoryApp
    {
        Task<Jugador> ValidateUser(Jugador usuario);

    }
}
