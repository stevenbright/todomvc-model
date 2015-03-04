-- Cheat:  sqlite3 --init story.sql


--
-- Catalog
--

CREATE TABLE lang_code (
  id            INTEGER PRIMARY KEY,
  code          CHAR(8) NOT NULL,
  CONSTRAINT uq_lang_code UNIQUE (code)
);

CREATE TABLE cat_item (
  id            INTEGER PRIMARY KEY,
  title         VARCHAR(256) NOT NULL,
  lang_id       INTEGER NOT NULL,
  cat_type      INTEGER NOT NULL,
  CONSTRAINT fk_cat_item_lang_id FOREIGN KEY (lang_id) REFERENCES lang_code (id)
);

CREATE TABLE ext_service (
  id            INTEGER NOT NULL,
  code          CHAR(8) NOT NULL,
  full_name     VARCHAR(256) NOT NULL,
  CONSTRAINT uq_ext_service_code UNIQUE (code),
  CONSTRAINT uq_ext_service_full_name UNIQUE (full_name)
);

CREATE TABLE ext_source (
  id            INTEGER PRIMARY KEY,
  source_data   VARCHAR(1024) NOT NULL
);

CREATE TABLE ext_cat_id (
  id            INTEGER PRIMARY KEY,
  cat_item_id   INTEGER NOT NULL,
  ext_id        CHAR(32) NOT NULL,
  ext_service_id INTEGER NOT NULL,
  ext_source_id INTEGER,
  CONSTRAINT fk_ext_cat_item_id FOREIGN KEY (cat_item_id) REFERENCES cat_item (id),
  CONSTRAINT fk_ext_cat_service_id FOREIGN KEY (ext_service_id) REFERENCES ext_service (id),
  CONSTRAINT fk_ext_cat_source_id FOREIGN KEY (ext_source_id) REFERENCES ext_source (id),
  CONSTRAINT uq_ext_cat_id UNIQUE (ext_id)
);


--
-- Content
--

CREATE TABLE comment_tree (
  id            INTEGER PRIMARY KEY,
  author_id     INTEGER NOT NULL,
  parent_id     INTEGER NOT NULL, -- comment, description or book id
  ct_type       INTEGER NOT NULL -- { BOOK, COMMENT, DESCRIPTION }
);

CREATE TABLE content (
  id            INTEGER PRIMARY KEY,
  c_type        INTEGER NOT NULL, -- { COMMENT, DESCRIPTION }
  host_id       INTEGER NOT NULL, -- comment, description or book id
  text          LONGTEXT NOT NULL,
  version       INTEGER NOT NULL,
  last_id       INTEGER NOT NULL,
  CONSTRAINT fk_content_last_id FOREIGN KEY (last_id) REFERENCES content (id)
);

CREATE TABLE description (
  id            INTEGER PRIMARY KEY,
  item_id       INTEGER NOT NULL, -- book id
  rating        INTEGER NOT NULL
);


--
-- P13n - Personalized user experience
--

CREATE TABLE favorite (
  user_id       INTEGER NOT NULL,
  entity_id     INTEGER NOT NULL, -- author, book, comment or description id
  entity_kind   INTEGER NOT NULL,
  CONSTRAINT pk_favorite PRIMARY KEY (user_id, entity_id, entity_kind)
);

CREATE TABLE friend (
  user_from     INTEGER NOT NULL,
  user_to       INTEGER NOT NULL,
  CONSTRAINT pk_friend PRIMARY KEY (user_from, user_to)
);

--
-- User - User accounts
--

