# payment-methods README

## Overview

Welcome to the README for my Rails project! 🚀 This project is built using Rails version 7.1.3 and Ruby version 3.2.2. It utilizes Tailwind for styling and incorporates various testing tools such as Rubocop, RSpec, and WebMock/RSpec. Additionally, it uses `net/http` and `uri` to interact with external APIs, specifically the Kobana API service.

## Purpose

The purpose of this project is to provide functionality for managing boletos (payment slips) on the platform using the Kobana API. Users can create, delete, update, and edit boletos through the provided API endpoints.

## Getting Started

To get started with the project, follow these steps:

1. Clone the repository to your local machine.
2. Ensure you have Ruby 3.2.2 installed.
3. Install Rails 7.1.3 if you haven't already.
4. Run `bundle install` to install project dependencies.
5. Set up your API token:
   - If you have your own Kobana API token, replace `yvjdS4XepSEM5Sen-I63oBAW6Dq75XIZR0Uv0A244cY` directly in the code.
   - For testing purposes, you can use the provided token `yvjdS4XepSEM5Sen-I63oBAW6Dq75XIZR0Uv0A244cY`.
6. Initialize the server using `./bin/dev` command due to Tailwind setup.
7. You're ready to start developing!

## API Documentation

### Overview

This project integrates with the Kobana API service. Below is a brief overview of the API documentation:

- **Format:** The API accepts JSON format for all requests.
- **Field Types:** Dates should be in ISO8601 format.
- **Conventions:** Various conventions are used throughout the documentation.
- **Response Codes:** Relevant HTTP response codes are provided along with descriptions.

For detailed API documentation, refer to the official Kobana API documentation.

### Security

- The Kobana API utilizes 2048-bit SSL certificates.
- All requests must use HTTPS protocol.
- Requests to port 80 are automatically redirected to port 443.
- TLSv1.2 or TLSv1.3 protocols are required.
- Supported ciphers are listed for secure communication.
- HTTP cache headers should be utilized to reduce server load.

For more security information, refer to the API documentation.

### Error Handling

- Server errors may result in 5xx status codes.
- Specific error codes and handling recommendations are provided.
- It is the responsibility of the application to handle and retry requests in case of errors.

For server status updates and maintenance information, visit the Kobana status page.

## Testing

This project includes RSpec tests along with WebMock for API request mocking. To run the tests, execute `bundle exec rspec` in your terminal.

## Dependencies

- Rails 7.1.3
- Ruby 3.2.2
- Tailwind CSS
- Rubocop
- RSpec
- WebMock
- net/http
- uri
- Autocomplete Search (Google API)

## Contributing

We welcome contributions to this project! If you have suggestions, enhancements, or bug fixes, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [GNU-3](LICENSE).

---
