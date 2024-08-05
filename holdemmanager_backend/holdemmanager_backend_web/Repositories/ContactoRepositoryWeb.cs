using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_web.Repositories
{
    public class ContactoRepositoryWeb : IContactoRepositoryWeb
    {
        private readonly AplicationDbContextWeb _context;

        public ContactoRepositoryWeb(AplicationDbContextWeb context)
        {
            this._context = context;
        }

        public async Task AddContacto(Contacto contacto)
        {
            _context.Contactos.Add(contacto);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteContacto(int id)
        {
            var contacto = await _context.Contactos.Where(c => c.Id == id).FirstOrDefaultAsync();

            if (contacto != null)
            {
                _context.Contactos.Remove(contacto);
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public async Task<PagedResult<Contacto>> GetAllContactos(int page, int pageSize)
        {
            var contactos = await _context.Contactos
                                 .Skip((page - 1) * pageSize)
                                 .Take(pageSize + 1)
                                 .ToListAsync();

            var hasNextPage = contactos.Count > pageSize;

            if (hasNextPage)
            {
                contactos.RemoveAt(pageSize);
            }

            return new PagedResult<Contacto>
            {
                Items = contactos,
                HasNextPage = hasNextPage
            };
        }

        public Task<Contacto> GetContactoById(int id)
        {
            var contacto = _context.Contactos.Where(c => c.Id == id).FirstOrDefaultAsync();
            if (contacto == null)
            {
                throw new Exception($"El contacto con id {id} no fue encontrado o no existe");
            }

            return contacto;
        }

        public async Task UpdateContacto(Contacto contacto)
        {
            _context.Update(contacto);
            await _context.SaveChangesAsync();
        }
    }
}
