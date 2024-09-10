# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_10_031543) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "hoardable_operation", ["update", "delete", "insert"]

  create_table "lists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.boolean "private"
    t.boolean "shared"
    t.datetime "shared_at"
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "lists", "users"
  create_function :hoardable_prevent_update_id, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.hoardable_prevent_update_id()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$BEGIN
        IF NEW.hoardable_id <> OLD.hoardable_id THEN
          RAISE EXCEPTION 'hoardable id cannot be updated';
        END IF;
        RETURN NEW;
      END;$function$
  SQL
  create_function :hoardable_source_set_id, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.hoardable_source_set_id()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$
      DECLARE
        _pk information_schema.constraint_column_usage.column_name%TYPE;
        _id _pk%TYPE;
      BEGIN
        SELECT c.column_name
          FROM information_schema.table_constraints t
          JOIN information_schema.constraint_column_usage c
          ON c.constraint_name = t.constraint_name
          WHERE c.table_name = TG_TABLE_NAME AND t.constraint_type = 'PRIMARY KEY'
          LIMIT 1
          INTO _pk;
        EXECUTE format('SELECT $1.%I', _pk) INTO _id USING NEW;
        NEW.hoardable_id = _id;
        RETURN NEW;
      END;$function$
  SQL
  create_function :hoardable_version_prevent_update, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.hoardable_version_prevent_update()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$BEGIN
        RAISE EXCEPTION 'updating a version is not allowed';
        RETURN NEW;
      END;$function$
  SQL


end
