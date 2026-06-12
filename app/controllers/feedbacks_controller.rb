class FeedbacksController < ApplicationController
    before_action :authenticate_admin!, only: [ :edit, :update, :destroy ]

    def index
        @feedbacks = Feedback.all
    end

    def new
        @feedback = Feedback.new
    end

    def create
        @feedback = Feedback.new(feedback_params)

        if @feedback.save
            redirect_to feedbacks_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @feedback = Feedback.find(params[:id])
    end

    def update
        @feedback = Feedback.find(params[:id])
        @feedback.update!(feedback_params)
        redirect_to dashboard_feedbacks_path
    end

    def destroy
        @feedback = Feedback.find(params[:id])
        @feedback.destroy
        redirect_to dashboard_feedbacks_path
    end

    private
    def feedback_params
        params.expect(feedback: [ :feedback, :rating, :order_id ])
    end
end
