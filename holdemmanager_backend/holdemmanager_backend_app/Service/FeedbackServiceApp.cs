using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Service
{
    public class FeedbackServiceApp : IFeedbackServiceApp
    {
        private readonly IFeedbackRepositoryApp _feedbackRepositoryApp;
        public FeedbackServiceApp(IFeedbackRepositoryApp feedbackServiceApp)
        {
            _feedbackRepositoryApp = feedbackServiceApp;   
        }
        public async Task AddFeedback(Feedback feedback)
        {
            await _feedbackRepositoryApp.AddFeedback(feedback);
        }

        public async Task<bool> DeleteFeedback(int id)
        {
            return await _feedbackRepositoryApp.DeleteFeedback(id);
        }

        public async Task<PagedResult<Feedback>> GetAllFeedbacks(int page, int pageSize)
        {
            return await _feedbackRepositoryApp.GetAllFeedbacks(page, pageSize);
        }

        public async Task<Feedback> GetFeedbackById(int id)
        {
            return await _feedbackRepositoryApp.GetFeedbackById(id);
        }

        public async Task UpdateFeedback(Feedback feedback)
        {
            await _feedbackRepositoryApp.UpdateFeedback(feedback);
        }
    }
}
