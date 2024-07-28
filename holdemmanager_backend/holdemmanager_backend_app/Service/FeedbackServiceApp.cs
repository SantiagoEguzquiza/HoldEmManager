using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace holdemmanager_backend_app.Service
{
    public class FeedbackServiceApp : IFeedbackServiceApp
    {
        private readonly IFeedbackRepositoryApp _feedbackServiceApp;
        public FeedbackServiceApp(IFeedbackRepositoryApp feedbackServiceApp)
        {
            _feedbackServiceApp = feedbackServiceApp;   
        }
        public async Task AddFeedback(Feedback feedback)
        {
            await _feedbackServiceApp.AddFeedback(feedback);
        }

        public async Task<bool> DeleteFeedback(int id)
        {
            return await _feedbackServiceApp.DeleteFeedback(id);
        }

        public async Task<IEnumerable<Feedback>> GetAllFeedbacks()
        {
            return await _feedbackServiceApp.GetAllFeedbacks();
        }

        public async Task<Feedback> GetFeedbackById(int id)
        {
            return await _feedbackServiceApp.GetFeedbackById(id);
        }

        public async Task UpdateFeedback(Feedback feedback)
        {
            await _feedbackServiceApp.UpdateFeedback(feedback);
        }
    }
}
