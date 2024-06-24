using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Service
{
    public class ContactoServiceWeb : IContactoServiceWeb
    {
        private readonly IContactoRepositoryWeb _contactoRepository;

        public ContactoServiceWeb(IContactoRepositoryWeb contactoRepository)
        {
            _contactoRepository = contactoRepository;
        }

        public async Task AddContacto(Contacto contacto)
        {
            await _contactoRepository.AddContacto(contacto);
        }

        public async Task<bool> DeleteContacto(int id)
        {
            return await _contactoRepository.DeleteContacto(id);
        }

        public async Task<IEnumerable<Contacto>> GetAllContactos()
        {
            return await _contactoRepository.GetAllContactos();
        }

        public async Task<Contacto> GetContactoById(int id)
        {
            return await _contactoRepository.GetContactoById(id);
        }

        public async Task UpdateContacto(Contacto contacto)
        {
            await _contactoRepository.UpdateContacto(contacto);
        }
    }
}
