using CSharpFunctionalExtensions;
using FluentValidation.Results;
using MediatR;
using RoomAggregate = Epam.ItMarathon.ApiService.Domain.Aggregate.Room.Room;

namespace Epam.ItMarathon.ApiService.Application.UseCases.User.Commands
{
    /// <summary>Команда обновления данных пользователя в комнате.</summary>
    public sealed record UpdateUsersRequest(
        string UserCode,
        ulong  UserId,
        string? FirstName,
        string? LastName,
        string? Email,
        string? Phone,
        string? DeliveryInfo,
        string? Interests,
        bool?  WantSurprise
    ) : IRequest<Result<RoomAggregate, ValidationResult>>;
}
