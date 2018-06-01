module Refinery
  module News
    module Admin
      class SettingsController < ::Refinery::AdminController
        def update
          @setting = Setting.find(params[:id])
          @setting.update_attributes(params.require(:setting).permit(:default_interval_in_months, :fresh_interval_in_months))

          return redirect_to :back
        end
      end
    end
  end
end