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
    public sealed class UpdateUsersHandler
        : IRequestHandler<UpdateUsersRequest, Result<RoomAggregate, ValidationResult>>
    {
        private readonly IRoomRepository _roomRepository;

        public UpdateUsersHandler(IRoomRepository roomRepository)
        {
            _roomRepository = roomRepository;
        }

        public async Task<Result<RoomAggregate, ValidationResult>> Handle(
            UpdateUsersRequest request,
            CancellationToken cancellationToken)
        {
            // Проверяем, существует ли комната по userCode
            var roomResult = await _roomRepository.GetByUserCodeAsync(request.UserCode, cancellationToken);
            if (roomResult.IsFailure)
                return Result.Failure<RoomAggregate, ValidationResult>(roomResult.Error);

            var room = roomResult.Value;

            // Ищем пользователя внутри комнаты
            var user = room.Users.FirstOrDefault(u => u.Id == request.UserId);
            if (user is null)
            {
                var vr = new ValidationResult(new[]
                {
                    new ValidationFailure(nameof(request.UserId), "User not found in this room.")
                });
                return Result.Failure<RoomAggregate, ValidationResult>(vr);
            }

            // Обновляем пользователя через доменную логику
            var update = user.Update(
                request.FirstName,
                request.LastName,
                request.Email,
                request.Phone,
                request.DeliveryInfo,
                request.Interests,
                request.WantSurprise
            );

            if (update.IsFailure)
                return Result.Failure<RoomAggregate, ValidationResult>(update.Error);

            // Сохраняем изменения комнаты (EF сам трекит юзера как часть агрегата)
            var save = await _roomRepository.UpdateAsync(room, cancellationToken);
            if (save.IsFailure)
            {
                var vr = new ValidationResult(new[]
                {
                    new ValidationFailure(string.Empty, save.Error)
                });
                return Result.Failure<RoomAggregate, ValidationResult>(vr);
            }

            // Возвращаем успешный результат
            return Result.Success<RoomAggregate, ValidationResult>(room);
        }
    }
}
