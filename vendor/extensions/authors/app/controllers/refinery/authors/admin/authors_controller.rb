module Refinery
  module Authors
    module Admin
      class AuthorsController < ::Refinery::AdminController

        crudify :'refinery/authors/author',
                :title_attribute => 'name'

        def index

          @root = Author.get_root!

        end

        def new

          @author = Author.new
          @parent = Author.get_root!

        end

        def create

          @parent = Author.find(params[:author][:author_id])

          if (@author = Author.create(author_params)).valid?
            flash.notice = t(
                'refinery.crudify.created',
                :what => @author.name
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
              if @author.update_attributes(author_params)
                flash.notice = t(
                    'refinery.crudify.updated',
                    :what => "'#{@author.name}'"
                )
                create_or_update_successful
              else
                create_or_update_unsuccessful 'edit'
              end
            }
            format.json {
              @author.update_position(
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

        # Only allow a trusted parameter "white list" through.
        def author_params
          params.require(:author).permit(:name, :poetry_header, :about_text, :friendly_header, :order_number, :author_id, :additional_info, :last_poem_placeholder, :need_placeholder)
        end
      end
    end
  end
end
