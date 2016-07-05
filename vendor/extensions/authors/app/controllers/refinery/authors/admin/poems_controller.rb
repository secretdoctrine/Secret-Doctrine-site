module Refinery
  module Authors
    module Admin
      class PoemsController < ::Refinery::AdminController

        before_action :find_all_authors

        crudify :'refinery/authors/poem',
                :title_attribute => 'title'

        def new

          @poem = Poem.new
          @parent = Author.find(params[:author_id])

        end

        def create

          @parent = Author.find(params[:poem][:author_id])

          if (@poem = Poem.create(poem_params)).valid?
            flash.notice = t(
                'refinery.crudify.created',
                :what => @poem.title
            )
            create_or_update_successful
          else
            #@book = Book.new
            create_or_update_unsuccessful 'new'
          end

        end

        def update
          respond_to do |format|

            format.html {
              if @poem.update_attributes(poem_params)
                flash.notice = t(
                    'refinery.crudify.updated',
                    :what => "'#{@poem.title}'"
                )
                create_or_update_successful
              else
                create_or_update_unsuccessful 'edit'
              end
            }
            format.json {
              @poem.update_position(
                  params[:new_parent].split('author_')[1].to_i,
                  params[:old_parent].split('author_')[1].to_i,
                  params[:new_position].to_i,
                  params[:old_position].to_i)
              render :nothing => true
            }
          end
        end

        private

        def create_or_update_unsuccessful(action)

          redirect_to :back

        end

        def find_all_authors
          @authors = Refinery::Authors::Author.all
        end

        # Only allow a trusted parameter "white list" through.
        def poem_params
          params.require(:poem).permit(
              :order_number, :content, :short_content, :picture_id, :author_id, :title, :image_caption,
              :tile_picture_id, :preview_picture_id, :name_second_line, :name_comment, :alt_top_block
          )
        end
      end
    end
  end
end
