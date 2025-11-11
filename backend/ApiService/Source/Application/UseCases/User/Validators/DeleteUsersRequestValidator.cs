using FluentValidation;
using Epam.ItMarathon.ApiService.Application.UseCases.User.Commands;

namespace Epam.ItMarathon.ApiService.Application.UseCases.User.Validators
{
    /// <summary>
    /// Валидация запроса на удаление пользователя.
    /// </summary>
    public sealed class DeleteUsersRequestValidator : AbstractValidator<DeleteUsersRequest>
    {
        public DeleteUsersRequestValidator()
        {
            RuleFor(x => x.UserCode)
                .NotEmpty().WithMessage("User code is required.");

            RuleFor(x => x.UserId)
                .Must(id => id > 0).WithMessage("User id must be greater than zero.");
        }
    }
}
