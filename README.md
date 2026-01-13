# workshop-platform-api

Production-grade backend API for managing workshops, registrations (tickets), organizer check-ins, and feedback.
Built with Spring Boot and PostgreSQL using best practices: Flyway migrations, stateless security, and Dockerized local dev.

## Tech Stack
- Java 21 (target)
- Spring Boot 3.x
- Spring Security (JWT access + refresh planned)
- PostgreSQL
- Flyway
- Docker & Docker Compose
- OpenAPI/Swagger (planned)
- CI: GitHub Actions (planned)
- Tests: JUnit + Testcontainers (planned)

## Features
### Implemented
- Dockerized PostgreSQL for local development
- Flyway migration-based schema initialization
- Stateless security skeleton
- Health check endpoint

### Planned
- JWT authentication (access + refresh)
- Role-based access (ADMIN / ORGANIZER / USER)
- Public workshop browsing (filters + pagination)
- Organizer workshop management (draft/publish/cancel)
- Registration + ticketing (capacity-safe)
- Check-in with ticket code
- Feedback (rating + comment)
- Global exception handling + standard error response
- Unit & integration tests (Testcontainers)
- CI pipeline + deployment

## Architecture
- Package-by-feature structure:
  - `auth`, `users`, `workshops`, `registrations`, `feedback`, `common`
- REST API versioning: `/api/v1/...`
- Database schema changes are managed via Flyway migrations (no Hibernate auto-ddl in prod)

## Local Development

### Requirements
- Java (recommended: 21)
- Docker & Docker Compose



### Start PostgreSQL
```bash
docker compose up -d
docker compose ps
```

### Configure Environment Variables

This project reads database credentials from environment variables.  
An example `.env` file is kept locally and **must not be committed** to version control.

Export variables into your shell session:

```bash
set -a
source .env
set +a
```

### Run the application
```bash
./mvnw spring-boot:run
```

### Verify
Health endpoint:
```bash
curl -i http://localhost:8080/api/v1/health
```

### Stop PostgreSQL (optional)
```bash
docker compose down
```

### Database
- PostgreSQL runs in Docker
- Schema is created/updated via Flyway migrations:
    - src/main/resources/db/migration/V1__init.sql

### Conventions
- Conventional Commits (feat:, chore:, docs:)
- DTO-based API (no entity exposure) — planned
- Bean Validation (@Valid) — planned
- Structured logging + global exception handler — planned

### Roadmap
See the checklist in the project planning notes and upcoming milestones:
- Auth (JWT)
- Workshops
- Registrations/Tickets
- Check-in
- Feedback
- Tests + CI
- Deployment + demo
