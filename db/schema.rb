# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171215181722) do

  create_table "book_categories", force: :cascade do |t|
    t.integer "book_category_id", limit: 4
    t.string  "name",             limit: 255, null: false
    t.boolean "is_root"
    t.integer "order_number",     limit: 4,   null: false
  end

  add_index "book_categories", ["book_category_id"], name: "index_book_categories_on_book_category_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.string  "name",             limit: 255, null: false
    t.string  "name_prefix",      limit: 255
    t.string  "tree_prefix",      limit: 255
    t.string  "name_comment",     limit: 255
    t.integer "order_number",     limit: 4,   null: false
    t.string  "picture_path",     limit: 255
    t.string  "synopsis",         limit: 255
    t.integer "year",             limit: 4
    t.string  "author",           limit: 255
    t.integer "page_count",       limit: 4
    t.integer "book_category_id", limit: 4,   null: false
  end

  add_index "books", ["book_category_id"], name: "index_books_on_book_category_id", using: :btree

  create_table "contents_elements", force: :cascade do |t|
    t.integer "book_id",             limit: 4,   null: false
    t.integer "contents_element_id", limit: 4
    t.integer "page_number",         limit: 4,   null: false
    t.string  "name_prefix",         limit: 255
    t.string  "name",                limit: 255, null: false
    t.string  "name_comment",        limit: 255
    t.integer "ce_type",             limit: 4,   null: false
  end

  add_index "contents_elements", ["book_id"], name: "index_contents_elements_on_book_id", using: :btree
  add_index "contents_elements", ["contents_element_id"], name: "index_contents_elements_on_contents_element_id", using: :btree

  create_table "external_book_contents", force: :cascade do |t|
    t.integer "book_id",      limit: 4,   null: false
    t.integer "content_type", limit: 4,   null: false
    t.string  "path",         limit: 255, null: false
  end

  add_index "external_book_contents", ["book_id"], name: "index_external_book_contents_on_book_id", using: :btree

  create_table "external_page_contents", force: :cascade do |t|
    t.integer "page_id",      limit: 4,   null: false
    t.integer "content_type", limit: 4,   null: false
    t.string  "path",         limit: 255, null: false
  end

  add_index "external_page_contents", ["page_id"], name: "index_external_page_contents_on_page_id", using: :btree

  create_table "internal_page_contents", force: :cascade do |t|
    t.integer "page_id",      limit: 4,   null: false
    t.integer "content_type", limit: 4,   null: false
    t.string  "content",      limit: 255, null: false
  end

  add_index "internal_page_contents", ["page_id"], name: "index_internal_page_contents_on_page_id", using: :btree

  create_table "news", force: :cascade do |t|
    t.text     "body",          limit: 65535,                 null: false
    t.boolean  "library_news",                default: false, null: false
    t.boolean  "site_news",                   default: false, null: false
    t.datetime "news_datetime",                               null: false
  end

  create_table "pages", force: :cascade do |t|
    t.integer "book_id",        limit: 4,                    null: false
    t.decimal "internal_order",               precision: 10, null: false
    t.string  "url_name",       limit: 255,                  null: false
    t.text    "page_text",      limit: 65535,                null: false
  end

  add_index "pages", ["book_id"], name: "index_pages_on_book_id", using: :btree

  create_table "refinery_authentication_devise_roles", force: :cascade do |t|
    t.string "title", limit: 255
  end

  create_table "refinery_authentication_devise_roles_users", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "refinery_authentication_devise_roles_users", ["role_id", "user_id"], name: "refinery_roles_users_role_id_user_id", using: :btree
  add_index "refinery_authentication_devise_roles_users", ["user_id", "role_id"], name: "refinery_roles_users_user_id_role_id", using: :btree

  create_table "refinery_authentication_devise_user_plugins", force: :cascade do |t|
    t.integer "user_id",  limit: 4
    t.string  "name",     limit: 255
    t.integer "position", limit: 4
  end

  add_index "refinery_authentication_devise_user_plugins", ["name"], name: "index_refinery_authentication_devise_user_plugins_on_name", using: :btree
  add_index "refinery_authentication_devise_user_plugins", ["user_id", "name"], name: "refinery_user_plugins_user_id_name", unique: true, using: :btree

  create_table "refinery_authentication_devise_users", force: :cascade do |t|
    t.string   "username",               limit: 255, null: false
    t.string   "email",                  limit: 255, null: false
    t.string   "encrypted_password",     limit: 255, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "sign_in_count",          limit: 4
    t.datetime "remember_created_at"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",                   limit: 255
    t.string   "full_name",              limit: 255
  end

  add_index "refinery_authentication_devise_users", ["id"], name: "index_refinery_authentication_devise_users_on_id", using: :btree
  add_index "refinery_authentication_devise_users", ["slug"], name: "index_refinery_authentication_devise_users_on_slug", using: :btree

  create_table "refinery_authors", force: :cascade do |t|
    t.string   "slug",            limit: 255
    t.string   "friendly_header", limit: 255
    t.string   "name",            limit: 255
    t.string   "poetry_header",   limit: 255
    t.text     "about_text",      limit: 65535
    t.integer  "position",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_authors", ["slug"], name: "index_refinery_authors_on_slug", using: :btree

  create_table "refinery_authors_poems", force: :cascade do |t|
    t.integer  "order",         limit: 4
    t.string   "title",         limit: 255
    t.text     "content",       limit: 65535
    t.text     "short_content", limit: 65535
    t.integer  "picture_id",    limit: 4
    t.integer  "author_id",     limit: 4
    t.integer  "position",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refinery_books", force: :cascade do |t|
    t.string   "name",             limit: 255,                   null: false
    t.string   "name_prefix",      limit: 255
    t.string   "tree_prefix",      limit: 255
    t.string   "name_comment",     limit: 255
    t.integer  "order_number",     limit: 4,                     null: false
    t.integer  "cover_picture_id", limit: 4
    t.integer  "book_file_id",     limit: 4
    t.text     "synopsis",         limit: 65535
    t.integer  "year",             limit: 4
    t.string   "author",           limit: 255
    t.integer  "page_count",       limit: 4
    t.boolean  "can_buy",                        default: false, null: false
    t.integer  "book_category_id", limit: 4
    t.integer  "position",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_books", ["book_category_id"], name: "index_refinery_books_on_book_category_id", using: :btree

  create_table "refinery_books_book_categories", force: :cascade do |t|
    t.integer  "book_category_id", limit: 4
    t.string   "name",             limit: 255,   null: false
    t.boolean  "is_root"
    t.integer  "order_number",     limit: 4,     null: false
    t.text     "synopsis",         limit: 65535
    t.integer  "position",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_books_book_categories", ["book_category_id"], name: "index_refinery_books_book_categories_on_book_category_id", using: :btree

  create_table "refinery_books_book_pages", force: :cascade do |t|
    t.integer "book_id",        limit: 4,                    null: false
    t.decimal "internal_order",               precision: 10, null: false
    t.string  "url_name",       limit: 255,                  null: false
    t.text    "page_text",      limit: 65535,                null: false
  end

  add_index "refinery_books_book_pages", ["book_id"], name: "index_refinery_books_book_pages_on_book_id", using: :btree

  create_table "refinery_books_contents_elements", force: :cascade do |t|
    t.integer "book_id",             limit: 4,   null: false
    t.integer "contents_element_id", limit: 4
    t.integer "page_number",         limit: 4,   null: false
    t.string  "name_prefix",         limit: 255
    t.string  "name",                limit: 255, null: false
    t.string  "name_comment",        limit: 255
    t.integer "ce_type",             limit: 4,   null: false
  end

  add_index "refinery_books_contents_elements", ["book_id"], name: "index_refinery_books_contents_elements_on_book_id", using: :btree
  add_index "refinery_books_contents_elements", ["contents_element_id"], name: "index_refinery_books_contents_elements_on_contents_element_id", using: :btree

  create_table "refinery_books_external_book_contents", force: :cascade do |t|
    t.integer "book_id",      limit: 4,   null: false
    t.integer "content_type", limit: 4,   null: false
    t.string  "path",         limit: 255, null: false
  end

  add_index "refinery_books_external_book_contents", ["book_id"], name: "index_refinery_books_external_book_contents_on_book_id", using: :btree

  create_table "refinery_books_external_page_contents", force: :cascade do |t|
    t.integer "book_page_id", limit: 4,   null: false
    t.integer "content_type", limit: 4,   null: false
    t.string  "path",         limit: 255, null: false
  end

  add_index "refinery_books_external_page_contents", ["book_page_id"], name: "index_refinery_books_external_page_contents_on_book_page_id", using: :btree

  create_table "refinery_books_internal_page_contents", force: :cascade do |t|
    t.integer "book_page_id", limit: 4,   null: false
    t.integer "content_type", limit: 4,   null: false
    t.string  "content",      limit: 255, null: false
  end

  add_index "refinery_books_internal_page_contents", ["book_page_id"], name: "index_refinery_books_internal_page_contents_on_book_page_id", using: :btree

  create_table "refinery_books_news_items", force: :cascade do |t|
    t.text     "body",          limit: 65535,                 null: false
    t.string   "title",         limit: 255,                   null: false
    t.boolean  "library_news",                default: false, null: false
    t.boolean  "site_news",                   default: true,  null: false
    t.datetime "news_datetime",                               null: false
    t.integer  "position",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refinery_image_translations", force: :cascade do |t|
    t.integer  "refinery_image_id", limit: 4,   null: false
    t.string   "locale",            limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "image_alt",         limit: 255
    t.string   "image_title",       limit: 255
  end

  add_index "refinery_image_translations", ["locale"], name: "index_refinery_image_translations_on_locale", using: :btree
  add_index "refinery_image_translations", ["refinery_image_id"], name: "index_refinery_image_translations_on_refinery_image_id", using: :btree

  create_table "refinery_images", force: :cascade do |t|
    t.string   "image_mime_type", limit: 255
    t.string   "image_name",      limit: 255
    t.integer  "image_size",      limit: 4
    t.integer  "image_width",     limit: 4
    t.integer  "image_height",    limit: 4
    t.string   "image_uid",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_title",     limit: 255
    t.string   "image_alt",       limit: 255
  end

  create_table "refinery_multimedia_groups", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.integer  "multimedia_group_id", limit: 4
    t.integer  "position",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refinery_multimedia_groups_multimedia_items", force: :cascade do |t|
    t.integer  "audio_file_id",       limit: 4
    t.string   "title",               limit: 255
    t.string   "video_link",          limit: 255
    t.string   "book_link",           limit: 255
    t.integer  "multimedia_group_id", limit: 4
    t.integer  "position",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refinery_news_items", force: :cascade do |t|
    t.text     "body",          limit: 65535
    t.boolean  "library_news"
    t.boolean  "site_news"
    t.datetime "news_datetime"
    t.integer  "position",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refinery_page_part_translations", force: :cascade do |t|
    t.integer  "refinery_page_part_id", limit: 4,          null: false
    t.string   "locale",                limit: 255,        null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "body",                  limit: 4294967295
  end

  add_index "refinery_page_part_translations", ["locale"], name: "index_refinery_page_part_translations_on_locale", using: :btree
  add_index "refinery_page_part_translations", ["refinery_page_part_id"], name: "index_refinery_page_part_translations_on_refinery_page_part_id", using: :btree

  create_table "refinery_page_parts", force: :cascade do |t|
    t.integer  "refinery_page_id", limit: 4
    t.string   "slug",             limit: 255
    t.text     "body",             limit: 4294967295
    t.integer  "position",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",            limit: 255
  end

  add_index "refinery_page_parts", ["id"], name: "index_refinery_page_parts_on_id", using: :btree
  add_index "refinery_page_parts", ["refinery_page_id"], name: "index_refinery_page_parts_on_refinery_page_id", using: :btree

  create_table "refinery_page_translations", force: :cascade do |t|
    t.integer  "refinery_page_id", limit: 4,   null: false
    t.string   "locale",           limit: 255, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "title",            limit: 255
    t.string   "custom_slug",      limit: 255
    t.string   "menu_title",       limit: 255
    t.string   "slug",             limit: 255
  end

  add_index "refinery_page_translations", ["locale"], name: "index_refinery_page_translations_on_locale", using: :btree
  add_index "refinery_page_translations", ["refinery_page_id"], name: "index_refinery_page_translations_on_refinery_page_id", using: :btree

  create_table "refinery_pages", force: :cascade do |t|
    t.integer  "parent_id",           limit: 4
    t.string   "path",                limit: 255
    t.string   "slug",                limit: 255
    t.string   "custom_slug",         limit: 255
    t.boolean  "show_in_menu",                    default: true
    t.string   "link_url",            limit: 255
    t.string   "menu_match",          limit: 255
    t.boolean  "deletable",                       default: true
    t.boolean  "draft",                           default: false
    t.boolean  "skip_to_first_child",             default: false
    t.integer  "lft",                 limit: 4
    t.integer  "rgt",                 limit: 4
    t.integer  "depth",               limit: 4
    t.string   "view_template",       limit: 255
    t.string   "layout_template",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "html_class_name",     limit: 255
  end

  add_index "refinery_pages", ["depth"], name: "index_refinery_pages_on_depth", using: :btree
  add_index "refinery_pages", ["id"], name: "index_refinery_pages_on_id", using: :btree
  add_index "refinery_pages", ["lft"], name: "index_refinery_pages_on_lft", using: :btree
  add_index "refinery_pages", ["parent_id"], name: "index_refinery_pages_on_parent_id", using: :btree
  add_index "refinery_pages", ["rgt"], name: "index_refinery_pages_on_rgt", using: :btree

  create_table "refinery_resource_translations", force: :cascade do |t|
    t.integer  "refinery_resource_id", limit: 4,   null: false
    t.string   "locale",               limit: 255, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "resource_title",       limit: 255
  end

  add_index "refinery_resource_translations", ["locale"], name: "index_refinery_resource_translations_on_locale", using: :btree
  add_index "refinery_resource_translations", ["refinery_resource_id"], name: "index_refinery_resource_translations_on_refinery_resource_id", using: :btree

  create_table "refinery_resources", force: :cascade do |t|
    t.string   "file_mime_type", limit: 255
    t.string   "file_name",      limit: 255
    t.integer  "file_size",      limit: 4
    t.string   "file_uid",       limit: 255
    t.string   "file_ext",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seo_meta", force: :cascade do |t|
    t.integer  "seo_meta_id",      limit: 4
    t.string   "seo_meta_type",    limit: 255
    t.string   "browser_title",    limit: 255
    t.text     "meta_description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seo_meta", ["id"], name: "index_seo_meta_on_id", using: :btree
  add_index "seo_meta", ["seo_meta_id", "seo_meta_type"], name: "id_type_index_on_seo_meta", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  add_foreign_key "book_categories", "book_categories"
  add_foreign_key "books", "book_categories"
  add_foreign_key "contents_elements", "books"
  add_foreign_key "contents_elements", "contents_elements"
  add_foreign_key "external_book_contents", "books"
  add_foreign_key "external_page_contents", "pages"
  add_foreign_key "internal_page_contents", "pages"
  add_foreign_key "pages", "books"
  add_foreign_key "refinery_books", "refinery_books_book_categories", column: "book_category_id", on_delete: :cascade
  add_foreign_key "refinery_books_book_categories", "refinery_books_book_categories", column: "book_category_id", on_delete: :cascade
  add_foreign_key "refinery_books_book_pages", "refinery_books", column: "book_id", on_delete: :cascade
  add_foreign_key "refinery_books_contents_elements", "refinery_books", column: "book_id", on_delete: :cascade
  add_foreign_key "refinery_books_contents_elements", "refinery_books_contents_elements", column: "contents_element_id", on_delete: :cascade
  add_foreign_key "refinery_books_external_book_contents", "refinery_books", column: "book_id", on_delete: :cascade
  add_foreign_key "refinery_books_external_page_contents", "refinery_books_book_pages", column: "book_page_id", on_delete: :cascade
  add_foreign_key "refinery_books_internal_page_contents", "refinery_books_book_pages", column: "book_page_id", on_delete: :cascade
end
