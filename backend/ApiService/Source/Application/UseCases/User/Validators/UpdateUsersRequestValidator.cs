using FluentValidation;
using Epam.ItMarathon.ApiService.Application.UseCases.User.Commands;

namespace Epam.ItMarathon.ApiService.Application.UseCases.User.Validators
{
    public sealed class UpdateUsersRequestValidator : AbstractValidator<UpdateUsersRequest>
    {
        public UpdateUsersRequestValidator()
        {
            RuleFor(x => x.UserCode).NotEmpty();
            RuleFor(x => x.UserId)
                .Must(id => id > 0).WithMessage("User id must be greater than zero.");

            // Пример мягких проверок
            RuleFor(x => x.Email).EmailAddress().When(x => !string.IsNullOrWhiteSpace(x.Email));
            RuleFor(x => x.Phone).MaximumLength(30).When(x => !string.IsNullOrWhiteSpace(x.Phone));
        }
    }
}
