# frozen_string_literal: true

class PostcodeValidationsController < ApplicationController
  def new
    @postcode_validation =  PostcodeValidation.new
  end

  def create
    @postcode_validation =  PostcodeValidation.new(postcode_validation_params)

    if @postcode_validation.valid?
      render "lookup_result"
    else
      flash[:error] = "Oh no! The postcode #{@postcode_validation.postcode} is invalid."
      redirect_to new_postcode_validation_path
    end
  end

  private

  def postcode_validation_params
    params.require(:postcode_validation).permit(:postcode)
  end
end
