using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Utils;
using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Domain.IServices
{
    public interface IFeedbackServiceApp
    {
        Task<PagedResult<Feedback>> GetAllFeedbacks(int page, int pageSize);
        Task<Feedback> GetFeedbackById(int id);
        Task AddFeedback(Feedback feedback);
        Task UpdateFeedback(Feedback feedback);
        Task<bool> DeleteFeedback(int id);
    }
}
