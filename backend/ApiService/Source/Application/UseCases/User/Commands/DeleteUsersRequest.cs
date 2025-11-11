using CSharpFunctionalExtensions;
using FluentValidation.Results;
using MediatR;
using RoomAggregate = Epam.ItMarathon.ApiService.Domain.Aggregate.Room.Room;

namespace Epam.ItMarathon.ApiService.Application.UseCases.User.Commands
{
    /// <summary>
    /// Команда удаления пользователя из комнаты по Id с авторизацией по userCode.
    /// </summary>
    public sealed record DeleteUsersRequest(string UserCode, ulong UserId)
        : IRequest<Result<RoomAggregate, ValidationResult>>;
}
