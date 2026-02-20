USE opinix_db;

DROP TABLE IF EXISTS summaries;
DROP TABLE IF EXISTS answer_options;
DROP TABLE IF EXISTS question_options;
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS responses;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS surveys;
DROP TABLE IF EXISTS ai_models;
DROP TABLE IF EXISTS users;

-- CREATE TABLES
-- USERS
CREATE TABLE users (
  user_id       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  full_name     VARCHAR(120) NOT NULL,
  email         VARCHAR(190) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role          ENUM('POLLSTER','RESPONDENT','ADMIN') NOT NULL DEFAULT 'RESPONDENT',
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB;

-- AI MODELS
CREATE TABLE ai_models (
  ai_model_id   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  model_name    VARCHAR(100) NOT NULL,
  ai_type       ENUM('SUMMARIZER','SENTIMENT','OTHER') NOT NULL DEFAULT 'SUMMARIZER',
  version       VARCHAR(50) NOT NULL DEFAULT 'v1',
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ai_model_id),
  KEY idx_ai_type (ai_type)
) ENGINE=InnoDB;

-- SURVEYS
CREATE TABLE surveys (
  survey_id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  title                   VARCHAR(200) NOT NULL,
  due_date                DATE NULL,
  estimated_time_minutes  INT NULL,
  is_open                 BOOLEAN NOT NULL DEFAULT TRUE,
  owner_user_id           BIGINT UNSIGNED NOT NULL,
  created_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (survey_id),
  KEY idx_surveys_owner (owner_user_id),
  KEY idx_surveys_is_open (is_open),
  CONSTRAINT fk_surveys_owner_user
    FOREIGN KEY (owner_user_id) REFERENCES users(user_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- QUESTIONS
CREATE TABLE questions (
  question_id     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  survey_id       BIGINT UNSIGNED NOT NULL,
  question_text   VARCHAR(500) NOT NULL,
  question_type   ENUM('OPEN','SINGLE_CHOICE','MULTI_CHOICE') NOT NULL,
  is_multi_answer BOOLEAN NOT NULL DEFAULT FALSE,
  sort_order      INT NOT NULL DEFAULT 1,
  PRIMARY KEY (question_id),
  KEY idx_questions_survey (survey_id),
  CONSTRAINT fk_questions_survey
    FOREIGN KEY (survey_id) REFERENCES surveys(survey_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- QUESTION OPTIONS
CREATE TABLE question_options (
  option_id     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  question_id   BIGINT UNSIGNED NOT NULL,
  option_text   VARCHAR(255) NOT NULL,
  sort_order    INT NOT NULL DEFAULT 1,
  PRIMARY KEY (option_id),
  KEY idx_qopts_question (question_id),
  CONSTRAINT fk_qopts_question
    FOREIGN KEY (question_id) REFERENCES questions(question_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- RESPONSES
CREATE TABLE responses (
  response_id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  survey_id            BIGINT UNSIGNED NOT NULL,
  respondent_user_id   BIGINT UNSIGNED NOT NULL,
  submitted_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (response_id),
  UNIQUE KEY uq_one_response_per_user_per_survey (survey_id, respondent_user_id),
  KEY idx_responses_survey (survey_id),
  KEY idx_responses_user (respondent_user_id),
  CONSTRAINT fk_responses_survey
    FOREIGN KEY (survey_id) REFERENCES surveys(survey_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_responses_respondent
    FOREIGN KEY (respondent_user_id) REFERENCES users(user_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- ANSWERS
CREATE TABLE answers (
  answer_id     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  response_id   BIGINT UNSIGNED NOT NULL,
  question_id   BIGINT UNSIGNED NOT NULL,
  answer_text   TEXT NULL,
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (answer_id),
  UNIQUE KEY uq_one_answer_per_question_per_response (response_id, question_id),
  KEY idx_answers_response (response_id),
  KEY idx_answers_question (question_id),
  CONSTRAINT fk_answers_response
    FOREIGN KEY (response_id) REFERENCES responses(response_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_answers_question
    FOREIGN KEY (question_id) REFERENCES questions(question_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- ANSWER OPTIONS
CREATE TABLE answer_options (
  answer_id   BIGINT UNSIGNED NOT NULL,
  option_id   BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (answer_id, option_id),
  CONSTRAINT fk_ansopt_answer
    FOREIGN KEY (answer_id) REFERENCES answers(answer_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_ansopt_option
    FOREIGN KEY (option_id) REFERENCES question_options(option_id)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- SUMMARIES
CREATE TABLE summaries (
  summary_id     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  survey_id      BIGINT UNSIGNED NOT NULL,
  owner_user_id  BIGINT UNSIGNED NOT NULL,
  ai_model_id    BIGINT UNSIGNED NOT NULL,
  summary_text   LONGTEXT NOT NULL,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (summary_id),
  KEY idx_summaries_survey (survey_id),
  KEY idx_summaries_owner (owner_user_id),
  KEY idx_summaries_model (ai_model_id),
  CONSTRAINT fk_summaries_survey
    FOREIGN KEY (survey_id) REFERENCES surveys(survey_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_summaries_owner
    FOREIGN KEY (owner_user_id) REFERENCES users(user_id)
    ON DELETE RESTRICT,
  CONSTRAINT fk_summaries_model
    FOREIGN KEY (ai_model_id) REFERENCES ai_models(ai_model_id)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

SHOW TABLES;