# Full-Stack with Flutter x Serverpod | Tech With Sam

[![Youtube](https://img.shields.io/static/v1?label=TechWithSam&message=Subscribe&logo=YouTube&color=FF0000&style=for-the-badge)](https://youtube.com/techwithsam)
[![Serverpod](https://img.shields.io/badge/Serverpod-Backend-blue)](https://docs.serverpod.dev) [![Flutter](https://img.shields.io/badge/Flutter-Client-02569B)](https://flutter.dev)
[![GitHub stars](https://img.shields.io/github/stars/techwithsam/fintech_todo_serverpod.svg?style=social&label=Star)](https://github.com/techwithsam/fintech_todo_serverpod)
[![GitHub TechWithSam](https://img.shields.io/github/followers/techwithsam?label=follow&style=social)](https://github.com/techwithsam)

## Overview

Top question on Stack Overflow this year: 'How do I build a backend without leaving Dart?'
Enter Serverpod—the open-source powerhouse that's making full-stack Dart the 2025 must-have. In this new series, we're building a real-world fintech to-do app from scratch: secure tasks, real-time updates, and cloud-ready deploys. No more half-solutions!

<a href="https://www.youtube.com/playlist?list=PLMfrNHAjWCoBLkkknD1iBOD-rUsejTWlj"> <img height="500"  width="800" alt="Youtube Banner" src="https://img.youtube.com/vi/lIseZ0DPAmg/0.jpg"></a>


[Course] Full-Stack Mobile Development With Flutter and Serverpod - [Watch on youtube](https://www.youtube.com/playlist?list=PLMfrNHAjWCoBLkkknD1iBOD-rUsejTWlj)

---

## Project layout

- fintech_todo_server/ — Serverpod server
  - bin/main.dart — server entrypoint
  - Dockerfile — for containerized deploys
  - migrations/ — DB migrations
  - lib/src/generated/ — generated protocol & endpoints
- fintech_todo_flutter/ — Flutter client
  - lib/main.dart — app entrypoint
- fintech_todo_client/ — generated client package

---

## Quick start

Prereqs: Docker, Flutter, Dart SDK (for server).

1. Clone:

   ```bash
   git clone https://github.com/techwithsam/fintech_todo_serverpod
   cd fintech_todo
   ```

2. Start local DB & Redis (example using docker-compose):

   ```bash
   cd fintech_todo_server && docker compose up -d
   ```

3. Run the server:

   ```bash
   # from fintech_todo/
   dart pub get
   dart run bin/main.dart
   # (or run with migrations)
   dart run bin/main.dart --apply-migrations
   ```

4. Run the Flutter app:

   ```bash
   cd ../fintech_todo_flutter
   flutter pub get
   flutter run
   ```

5. Access localhp:

   ```bash
   curl http://localhost:8080/
   ```

---

## Development tips

- Regenerate client after changing server models/endpoints:

  ```bash
  # from fintech_todo_server/
  serverpod generate
  ```

- Set SERVER_URL in Flutter (web / build):

  ```bash
  flutter build web --dart-define=SERVER_URL=https://your-app.example
  ```

---

## Deployment

See DEPLOYMENT.md for step‑by‑step Railway and Heroku instructions, Dockerfile, env vars, and common fixes.

Quick notes:

- Use production config: `config/production.yaml`
- Apply migrations on first deploy
- Ensure port 8080 exposed and publicHost set to your domain

---

## License

MIT — see LICENSE file.

<!-- end -->