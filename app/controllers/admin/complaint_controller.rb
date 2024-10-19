module Admin
    class ComplaintsController < ApplicationController
      before_action :authenticate_admin! # Assuming there's admin authentication
  
      def index
        @complaints = Complaint.all.order(created_at: :desc) # Fetch complaints for admin
      end
    end
  end
  