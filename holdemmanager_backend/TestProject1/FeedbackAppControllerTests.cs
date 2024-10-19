using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Xunit;
using Moq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using holdemmanager_backend_app.Controllers;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Domain.Models;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_app.Utils;

public class FeedbackAppControllerTests
{
    private readonly Mock<IFeedbackServiceApp> _mockFeedbackService;
    private readonly AplicationDbContextApp _dbContext;
    private readonly FeedbackAppController _controller;

    public FeedbackAppControllerTests()
    {
        _mockFeedbackService = new Mock<IFeedbackServiceApp>();

        var options = new DbContextOptionsBuilder<AplicationDbContextApp>()
            .UseInMemoryDatabase(databaseName: "TestDatabase")
            .Options;

        _dbContext = new AplicationDbContextApp(options);
        _controller = new FeedbackAppController(_dbContext, _mockFeedbackService.Object);
    }

    [Fact]
    public async Task GetAllFeedbacks_ReturnsOkResult_WithListOfFeedbacks()
    {
        // Arrange
        int page = 1;
        int pageSize = 10;
        var pagedResult = new PagedResult<Feedback>
        {
            Items = new List<Feedback>(),
            HasNextPage = false
        };
        _mockFeedbackService.Setup(service => service.GetAllFeedbacks(page, pageSize)).ReturnsAsync(pagedResult);

        // Act
        var result = await _controller.GetAllFeedbacks(page, pageSize);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(pagedResult, okResult.Value);
    }

    [Fact]
    public async Task GetFeedbackById_ReturnsOkResult_WithFeedback()
    {
        // Arrange
        int feedbackId = 1;
        var feedback = new Feedback
        {
            Id = feedbackId,
            Fecha = DateTime.Now,
            Mensaje = "Prueba de feedback",
            Categoria = FeedbackEnum.ESTRUCTURA,
            IsAnonimo = false
        };
        _mockFeedbackService.Setup(service => service.GetFeedbackById(feedbackId)).ReturnsAsync(feedback);

        // Act
        var result = await _controller.GetFeedbackById(feedbackId);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(feedback, okResult.Value);
    }

    [Fact]
    public async Task AddFeedback_ReturnsOkResult_WithSuccessMessage()
    {
        // Arrange
        var feedback = new Feedback
        {
            Id = 1,
            Fecha = DateTime.Now,
            Mensaje = "Nuevo feedback",
            Categoria = FeedbackEnum.INSCRIPCION,
            IdUsuario = 1,
            IsAnonimo = false
        };

        var jugador = new Jugador
        {
            Id = 1,
            Email = "test@example.com",  // Asegúrate de incluir todas las propiedades requeridas
            Name = "Jugador de prueba",
            Password = "password123",
            Feedbacks = new List<Feedback>()
        };

        // Agrega el jugador a la base de datos en memoria
        _dbContext.Jugadores.Add(jugador);
        await _dbContext.SaveChangesAsync();

        _mockFeedbackService.Setup(service => service.AddFeedback(feedback)).Returns(Task.CompletedTask);

        // Act
        var result = await _controller.AddFeedback(feedback);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        var messageProperty = okResult.Value.GetType().GetProperty("message");
        var messageValue = messageProperty.GetValue(okResult.Value, null);

        Assert.Equal("Feedback agregado exitosamente.", messageValue);
    }

    [Fact]
    public async Task DeleteFeedback_ReturnsOkResult_WithSuccessMessage()
    {
        // Arrange
        int feedbackId = 1;
        var feedback = new Feedback
        {
            Id = feedbackId,
            Fecha = DateTime.Now,
            Mensaje = "Feedback para eliminar",
            Categoria = FeedbackEnum.PREMIOS,
            IsAnonimo = false
        };
        _mockFeedbackService.Setup(service => service.GetFeedbackById(feedbackId)).ReturnsAsync(feedback);
        _mockFeedbackService.Setup(service => service.DeleteFeedback(feedbackId)).ReturnsAsync(true);

        // Act
        var result = await _controller.DeleteFeedback(feedbackId);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);

        var messageProperty = okResult.Value.GetType().GetProperty("message");
        Assert.NotNull(messageProperty);
        var messageValue = messageProperty.GetValue(okResult.Value, null);

        Assert.Equal("Feedback eliminado exitosamente.", messageValue);
    }
}