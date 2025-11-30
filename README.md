Türk Medeniyeti - Complete System

This package contains a full-stack scaffold:
- backend (Express + Postgres + Socket.io)
- react_full (Next.js) frontend
- discord_bot (Discord.js)
- docker-compose to run everything locally (postgres + pgAdmin included)

Quickstart:
- copy to your machine, set env vars: DISCORD_TOKEN, DISCORD_CLIENT_ID, DISCORD_GUILD_ID
- docker-compose up --build
- register commands: cd discord_bot && node register_commands.js
- optionally run: cd react_full && npm install && npm run dev


Admin setup:
- Copy .env.example to .env and set ADMIN_EMAIL and ADMIN_PASSWORD.
- Start docker-compose: docker-compose up --build
- After DB is up, run one-time admin registration via curl:
  curl -X POST http://localhost:4000/api/admin/register -H 'Content-Type: application/json' -d '{"email":"admin@local","password":"ChangeMeSecurely!"}'
- Then login via react_full/admin/login to obtain JWT and use Admin Panel.


Security & production notes:
- Set JWT_SECRET to a strong random value.
- Use HTTPS in production (reverse proxy like Nginx or Traefik). Docker Compose here is for dev.
- Limit CORS_ORIGIN environment variable to your frontend domain.
- Consider using a secret manager (Vault, GitHub Secrets, etc.) for tokens.

To push to GitHub quickly use: ./git_push_setup.sh git@github.com:YOURUSER/turk-medeniyeti.git
