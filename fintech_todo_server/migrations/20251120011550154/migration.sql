BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "amount" double precision NOT NULL,
    "dueDate" timestamp without time zone,
    "userId" bigint NOT NULL
);


--
-- MIGRATION VERSION FOR fintech_todo
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('fintech_todo', '20251120011550154', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251120011550154', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
