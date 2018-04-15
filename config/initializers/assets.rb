# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( books/lightbox.js )
Rails.application.config.assets.precompile += %w( multimedia_groups/jquery.jplayer.js )
Rails.application.config.assets.precompile += %w( multimedia_groups/jplayer.playlist.min.js )
Rails.application.config.assets.precompile += %w( multimedia_groups/jplayer.blue.monday.css )
Rails.application.config.assets.precompile += %w( poetry.css )
Rails.application.config.assets.precompile += %w( refinery/books/jstree.css )
Rails.application.config.assets.precompile += %w( refinery/books/jstree-actions.js )
Rails.application.config.assets.precompile += %w( refinery/books/highslide-full.packed.js )
Rails.application.config.assets.precompile += %w( multimedia.css )
Rails.application.config.assets.precompile += %w( feedback.css )
Rails.application.config.assets.precompile += %w( news.css )
Rails.application.config.assets.precompile += %w( admin_tree.css )
Rails.application.config.assets.precompile += %w( multimedia_groups/jplayer-style.css )
Rails.application.config.assets.precompile += %w( multimedia_groups/themicons.css )
Rails.application.config.assets.precompile += %w( /\.(?:svg|eot|woff|ttf)\z/ )
