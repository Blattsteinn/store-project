class FeedbacksController < ApplicationController
    def index
        @feedbacks = Feedback.all
    end

    def new
        @feedback = Feedback.new
    end

    def create
        @feedback = Feedback.new(feedback_params)
        @feedback.user_id = current_user.id

        if @feedback.save
            redirect_to feedbacks_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        authenticate_admin!
        @feedback = Feedback.find(params[:id])
    end

    def update
        authenticate_admin!
        @feedback = Feedback.find(params[:id])
        @feedback.update!(feedback_params)
        redirect_to dashboard_feedbacks_path
    end

    def destroy
        authenticate_admin!
        @feedback = Feedback.find(params[:id])
        @feedback.destroy
        redirect_to dashboard_feedbacks_path
    end

    private
    def feedback_params
        params.expect(feedback: [:feedback, :rating, :order_id])
    end
end
