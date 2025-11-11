

namespace Epam.ItMarathon.ApiService.Api.Dto.Requests.UserRequests
{
    public sealed class UserUpdateRequest
    {
        public string FirstName { get; init; } = string.Empty;
        public string LastName  { get; init; } = string.Empty;
        public string? Email    { get; init; }
        public string? Phone    { get; init; }
        public string? DeliveryInfo { get; init; }
        public string? Interests    { get; init; }
        public bool?   WantSurprise { get; init; }
    }
}
