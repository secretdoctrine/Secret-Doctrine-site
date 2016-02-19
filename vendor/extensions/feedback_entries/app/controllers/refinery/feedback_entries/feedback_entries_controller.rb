module Refinery
  module FeedbackEntries
    class FeedbackEntriesController < ::ApplicationController

      before_action :find_page

      def index
        return redirect_to refinery.new_feedback_entries_feedback_entry_path
      end

      def new
        @feedback_entry = FeedbackEntry.new

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @feedback_entry in the line below:
        present(@page)
      end

      def create

        if (@feedback_entry = FeedbackEntry.create(feedback_entry_params)).valid?
          flash.notice = t(
            'refinery.crudify.created',
            :what => @feedback_entry.entry_title
          )
          Refinery::Authentication::Devise::User.all.collect{|x| x.email}.each do |email|
            DoctrineMailer.new_feedback(email, @feedback_entry).deliver_later
          end
          @feedback_entry = FeedbackEntry.new
          return redirect_to refinery.new_feedback_entries_feedback_entry_path
        end

        render :new

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
