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
    end

    def update
    end

    def destroy
    end

    private
    def feedback_params
        params.expect(feedback: [:feedback, :rating, :order_id])
    end
end
