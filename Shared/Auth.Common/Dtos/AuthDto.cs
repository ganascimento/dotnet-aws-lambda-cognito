namespace Auth.Common.Dtos
{
    public class AuthDto
    {
        public string Email { get; set; }
        public string Password { get; set; }

        public AuthDto(string email, string password)
        {
            this.Email = email;
            this.Password = password;

            Validate();
        }

        private void Validate()
        {
            if (string.IsNullOrEmpty(this.Email)) throw new InvalidDataException("Email is invalid");
            if (string.IsNullOrEmpty(this.Password)) throw new InvalidDataException("Password is invalid");
        }
    }
}