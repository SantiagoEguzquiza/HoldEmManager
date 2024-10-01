using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Xunit;
using Moq;
using Microsoft.AspNetCore.Mvc;
using holdemmanager_backend_web.Controllers;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Domain.Models;
using holdemmanager_backend_web.Utils;

public class ContactoWebControllerTests
{
    private readonly Mock<IContactoServiceWeb> _mockContactosService;
    private readonly ContactoWebController _controller;

    public ContactoWebControllerTests()
    {
        _mockContactosService = new Mock<IContactoServiceWeb>();
        _controller = new ContactoWebController(_mockContactosService.Object);
    }

    [Fact]
    public async Task GetAllContactos_ReturnsOkResult_WithListOfContactos()
    {
        // Arrange
        int page = 1;
        int pageSize = 10;
        var pagedResult = new PagedResult<Contacto>
        {
            Items = new List<Contacto>(),
            HasNextPage = false
        };
        _mockContactosService.Setup(service => service.GetAllContactos(page, pageSize)).ReturnsAsync(pagedResult);

        // Act
        var result = await _controller.GetAllContactos(page, pageSize);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(pagedResult, okResult.Value);
    }

    [Fact]
    public async Task GetContactoById_ReturnsOkResult_WithContacto()
    {
        // Arrange
        int contactoId = 1;
        var contacto = new Contacto
        {
            Id = contactoId,
            InfoCasino = "Casino Test",
            Direccion = "123 Test Street",
            NumeroTelefono = "123456789",
            Email = "test@example.com"
        };
        _mockContactosService.Setup(service => service.GetContactoById(contactoId)).ReturnsAsync(contacto);

        // Act
        var result = await _controller.GetContactoById(contactoId);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(contacto, okResult.Value);
    }

    [Fact]
    public async Task AddContacto_ReturnsOkResult_WithSuccessMessage()
    {
        // Arrange
        var contacto = new Contacto
        {
            Id = 1,
            InfoCasino = "Casino Nuevo",
            Direccion = "456 Nueva Calle",
            NumeroTelefono = "987654321",
            Email = "nuevo@example.com"
        };

        _mockContactosService.Setup(service => service.AddContacto(contacto)).Returns(Task.CompletedTask);

        // Act
        var result = await _controller.AddContacto(contacto);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);

        var messageProperty = okResult.Value.GetType().GetProperty("message");
        var messageValue = messageProperty.GetValue(okResult.Value, null);

        Assert.Equal("Contacto agregado exitosamente.", messageValue);
    }

    [Fact]
    public async Task UpdateRecurso_ReturnsOkResult_WithSuccessMessage()
    {
        // Arrange
        var contacto = new Contacto
        {
            Id = 1,
            InfoCasino = "Casino Actualizado",
            Direccion = "789 Calle Actualizada",
            NumeroTelefono = "111222333",
            Email = "actualizado@example.com"
        };

        _mockContactosService.Setup(service => service.UpdateContacto(contacto)).Returns(Task.CompletedTask);

        // Act
        var result = await _controller.UpdateRecurso(contacto.Id, contacto);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);

        var messageProperty = okResult.Value.GetType().GetProperty("message");
        Assert.NotNull(messageProperty);
        var messageValue = messageProperty.GetValue(okResult.Value, null);

        Assert.Equal("Contacto agregado exitosamente.", messageValue);
    }

    [Fact]
    public async Task DeleteRecurso_ReturnsOkResult_WithSuccessMessage()
    {
        // Arrange
        int contactoId = 1;
        var contacto = new Contacto
        {
            Id = contactoId,
            InfoCasino = "Casino para Eliminar",
            Direccion = "000 Calle Ejemplo",
            NumeroTelefono = "444555666",
            Email = "eliminar@example.com"
        };
        _mockContactosService.Setup(service => service.GetContactoById(contactoId)).ReturnsAsync(contacto);
        _mockContactosService.Setup(service => service.DeleteContacto(contactoId)).ReturnsAsync(true);

        // Act
        var result = await _controller.DeleteRecurso(contactoId);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);

        // Utiliza reflexión para obtener el valor de la propiedad 'message' del tipo anónimo
        var messageProperty = okResult.Value.GetType().GetProperty("message");
        Assert.NotNull(messageProperty); // Verifica que la propiedad existe
        var messageValue = messageProperty.GetValue(okResult.Value, null);

        Assert.Equal("Contacto eliminado exitosamente.", messageValue);
    }
}