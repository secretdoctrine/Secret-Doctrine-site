module Refinery
  module MultimediaGroups
    class MultimediaItemsController < ::ApplicationController

      before_action :find_all_multimedia_items, :find_page

      def file

        item = MultimediaItem.find_by_id(params[:id])

        return nil if item.nil?

        #response.headers['Content-Length'] = item.audio_file.file.size.to_s
        #response.headers['Accept-Ranges'] = 'bytes'
        #response.headers['Content-Range'] = "bytes 0-#{(item.audio_file.file.size-1).to_s}/#{(item.audio_file.file.size).to_s}"
        #send_data(item.audio_file.file.data, type: 'audio/mpeg', status: 206)

        if request.headers["HTTP_RANGE"]

          size = item.audio_file.file.size
          bytes = Rack::Utils.byte_ranges(request.headers, size)[0]
          offset = bytes.begin
          length = bytes.end - bytes.begin + 1

          response.header["Accept-Ranges"]=  "bytes"
          response.header["Content-Range"] = "bytes #{bytes.begin}-#{bytes.end}/#{size}"
          response.header["Content-Length"] = "#{length}"

          send_data IO.binread(item.audio_file.file.path,length, offset), :type => "audio/mpeg", :stream => true,  :disposition => 'inline',
                    :file_name => item.audio_file.file.name

        else
          send_file(file_path, :disposition => 'inline', :stream => true, :file_name => file_name)
        end

      end

    protected

      def find_all_multimedia_items
        @multimedia_items = MultimediaItem.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/multimedia_groups").first
      end

    end
  end
end
