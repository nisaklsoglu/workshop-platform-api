-- V1: Initial schema

-- (Opsiyonel) UUID üretimini DB'de yapmak istersen:
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  role VARCHAR(32) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE workshops (
  id UUID PRIMARY KEY,
  organizer_id UUID NOT NULL REFERENCES users(id),
  title VARCHAR(200) NOT NULL,
  description TEXT,
  location VARCHAR(200),
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  capacity INT NOT NULL,
  status VARCHAR(32) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_workshops_organizer_id ON workshops(organizer_id);
CREATE INDEX idx_workshops_status ON workshops(status);
CREATE INDEX idx_workshops_start_time ON workshops(start_time);

CREATE TABLE registrations (
  id UUID PRIMARY KEY,
  workshop_id UUID NOT NULL REFERENCES workshops(id),
  user_id UUID NOT NULL REFERENCES users(id),
  ticket_code VARCHAR(64) NOT NULL UNIQUE,
  status VARCHAR(32) NOT NULL,
  checked_in_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uq_reg_workshop_user UNIQUE (workshop_id, user_id)
);

CREATE INDEX idx_registrations_workshop_id ON registrations(workshop_id);
CREATE INDEX idx_registrations_user_id ON registrations(user_id);

CREATE TABLE feedback (
  id UUID PRIMARY KEY,
  workshop_id UUID NOT NULL REFERENCES workshops(id),
  user_id UUID NOT NULL REFERENCES users(id),
  rating INT NOT NULL,
  comment TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uq_feedback_workshop_user UNIQUE (workshop_id, user_id)
);

CREATE INDEX idx_feedback_workshop_id ON feedback(workshop_id);

-- Basit CHECK constraint'ler (enum yerine text + check)
ALTER TABLE users
  ADD CONSTRAINT chk_users_role
  CHECK (role IN ('ADMIN', 'ORGANIZER', 'USER'));

ALTER TABLE workshops
  ADD CONSTRAINT chk_workshops_status
  CHECK (status IN ('DRAFT', 'PUBLISHED', 'CANCELLED'));

ALTER TABLE workshops
  ADD CONSTRAINT chk_workshops_capacity
  CHECK (capacity > 0);

ALTER TABLE workshops
  ADD CONSTRAINT chk_workshops_time
  CHECK (start_time < end_time);

ALTER TABLE registrations
  ADD CONSTRAINT chk_registrations_status
  CHECK (status IN ('ACTIVE', 'CANCELLED'));

ALTER TABLE feedback
  ADD CONSTRAINT chk_feedback_rating
  CHECK (rating BETWEEN 1 AND 5);
