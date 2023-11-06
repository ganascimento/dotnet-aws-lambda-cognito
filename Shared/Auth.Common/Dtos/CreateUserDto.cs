namespace Auth.Common.Dtos
{
    public class CreateUserDto
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public string Name { get; set; }

        public CreateUserDto(string email, string password, string name)
        {
            this.Email = email;
            this.Password = password;
            this.Name = name;

            Validate();
        }

        private void Validate()
        {
            if (string.IsNullOrEmpty(this.Email)) throw new InvalidDataException("Email is invalid");
            if (string.IsNullOrEmpty(this.Password)) throw new InvalidDataException("Password is invalid");
            if (string.IsNullOrEmpty(this.Name)) throw new InvalidDataException("Name is invalid");
        }
    }
}