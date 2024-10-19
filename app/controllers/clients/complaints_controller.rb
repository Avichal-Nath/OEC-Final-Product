module Clients
  class ComplaintsController < ApplicationController
    def index
      @complaints = Complaint.all
    end

    def new
      @complaint = Complaint.new
    end

    def create
      @complaint = Complaint.new(complaint_params)
      if @complaint.save
        redirect_to clients_complaints_success_path
      else
        render :new
      end
    end

    def success
      # This will render the success page with the message
    end

    private

    def complaint_params
      params.require(:complaint).permit(:name, :email, :product_name, :product_link, :complaint_text)
    end
  end
end
