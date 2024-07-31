using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_app.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Repositories
{
    public class FeedbackRepositoryApp : IFeedbackRepositoryApp
    {
        private readonly AplicationDbContextApp _context;
        public FeedbackRepositoryApp(AplicationDbContextApp context)
        {
            this._context = context; 
        }
        public async Task AddFeedback(Feedback devolucion)
        {
            _context.Feedback.Add(devolucion);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteFeedback(int id)
        {
            var devolucion = await _context.Feedback.Where(c => c.Id == id).FirstOrDefaultAsync();

            if (devolucion != null)
            {
                _context.Feedback.Remove(devolucion);
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public async Task<PagedResult<Feedback>> GetAllFeedbacks(int page, int pageSize)
        {
            var feedbacks = await _context.Feedback
                                 .Skip((page - 1) * pageSize)
                                 .Take(pageSize + 1)
                                 .ToListAsync();

            var hasNextPage = feedbacks.Count > pageSize;

            if (hasNextPage)
            {
                feedbacks.RemoveAt(pageSize);
            }

            return new PagedResult<Feedback>
            {
                Items = feedbacks,
                HasNextPage = hasNextPage
            };
        }

        public async Task<Feedback> GetFeedbackById(int id)
        {
            var devolucion = await _context.Feedback.Where(c => c.Id == id).FirstOrDefaultAsync();
            if (devolucion == null)
            {
                throw new Exception($"El feedback con id {id} no fue encontrado o no existe");
            }

            return devolucion;
        }

        public async Task UpdateFeedback(Feedback feedback)
        {
            _context.Update(feedback);
            await _context.SaveChangesAsync();
        }
    }
}
