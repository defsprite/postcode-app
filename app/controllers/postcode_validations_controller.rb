# frozen_string_literal: true

class PostcodeValidationsController < ApplicationController
  def new
    @postcode_validation =  PostcodeValidationForm.new
  end

  def create
    postcode_validation =  PostcodeValidationForm.new(postcode_validation_params)

    if postcode_validation.valid?
      @result = postcode_validation.result
      render "lookup_result"
    else
      flash[:error] = postcode_validation.flash_message
      redirect_to new_postcode_validation_path
    end
  end

  private

  def postcode_validation_params
    params.require(:postcode_validation_form).permit(:postcode)
  end
end
