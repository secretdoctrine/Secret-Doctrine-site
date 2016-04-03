module Refinery
  module FeedbackEntries
    class FeedbackEntriesController < ::ApplicationController

      before_action :find_page, :set_page_title

      def set_page_title
        @page_title = t('headers.feedback')
      end

      def index
        redirect_to refinery.new_feedback_entries_feedback_entry_path
      end

      def new
        @feedback_entry = FeedbackEntry.new

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @feedback_entry in the line below:
        present(@page)
      end

      def create

        @feedback_entry = FeedbackEntry.new(feedback_entry_params)
        if verify_recaptcha(model: @feedback_entry) and @feedback_entry.save and @feedback_entry.valid?
          flash.notice = t(
            'feedback.send_successful'
          )
          Refinery::Authentication::Devise::User.all.collect{|x| x.email}.each do |email|
            begin
              DoctrineMailer.new_feedback(email, @feedback_entry).deliver_later
            rescue Exception => e
              #print e
            end
          end
          @feedback_entry = FeedbackEntry.new
          return redirect_to refinery.new_feedback_entries_feedback_entry_path
        end

        flash.alert = @feedback_entry.errors.messages

        redirect_to :back

      end

    protected

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/feedback_entries").first
      end

      def feedback_entry_params
        params.require(:feedback_entry).permit(:poster_name, :poster_email, :entry_title, :entry_text, :attachment)
      end

    end
  end
end
