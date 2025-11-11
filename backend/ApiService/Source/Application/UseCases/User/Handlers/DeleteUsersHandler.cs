using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using CSharpFunctionalExtensions;
using FluentValidation.Results;
using MediatR;
using Epam.ItMarathon.ApiService.Application.UseCases.User.Commands;
using Epam.ItMarathon.ApiService.Domain.Abstract;
using RoomAggregate = Epam.ItMarathon.ApiService.Domain.Aggregate.Room.Room;

namespace Epam.ItMarathon.ApiService.Application.UseCases.User.Handlers
{
    public sealed class DeleteUsersHandler
        : IRequestHandler<DeleteUsersRequest, Result<RoomAggregate, ValidationResult>>
    {
        private readonly IRoomRepository _roomRepository;

        public DeleteUsersHandler(IRoomRepository roomRepository)
        {
            _roomRepository = roomRepository;
        }

        public async Task<Result<RoomAggregate, ValidationResult>> Handle(
            DeleteUsersRequest request,
            CancellationToken cancellationToken)
        {
            var roomResult = await _roomRepository.GetByUserCodeAsync(request.UserCode, cancellationToken);
            if (roomResult.IsFailure)
                return Result.Failure<RoomAggregate, ValidationResult>(roomResult.Error);

            var room = roomResult.Value;

            // ищем «актора» по AuthCode (НЕ UserCode)
            var actor = room.Users.FirstOrDefault(u => u.AuthCode == request.UserCode);
            if (actor is null)
                return Result.Failure<RoomAggregate, ValidationResult>(
                    new ValidationResult(new[] { new ValidationFailure("userCode", "Invalid user code.") }));

            if (actor.Id == request.UserId)
                return Result.Failure<RoomAggregate, ValidationResult>(
                    new ValidationResult(new[] { new ValidationFailure("userId", "You cannot delete yourself.") }));

            if (room.ClosedOn is not null)
            {
                var reopen = room.Reopen();
                if (reopen.IsFailure)
                    return Result.Failure<RoomAggregate, ValidationResult>(reopen.Error);
            }

            var deleteResult = room.DeleteUser(request.UserId);
            if (deleteResult.IsFailure)
                return Result.Failure<RoomAggregate, ValidationResult>(deleteResult.Error);

            var updateResult = await _roomRepository.UpdateAsync(room, cancellationToken);
            if (updateResult.IsFailure)
            {
                var failures = new[] { new ValidationFailure(string.Empty, updateResult.Error) };
                return Result.Failure<RoomAggregate, ValidationResult>(new ValidationResult(failures));
            }

            return Result.Success<RoomAggregate, ValidationResult>(room);
        }
    }
}
