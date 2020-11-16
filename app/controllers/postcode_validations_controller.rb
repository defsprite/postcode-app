# frozen_string_literal: true

class PostcodeValidationsController < ApplicationController
  def new
    @postcode_validation =  PostcodeValidation.new
  end

  def create
    @postcode_validation =  PostcodeValidation.new(postcode_validation_params)

    render "lookup_result"
  end

  private

  def postcode_validation_params
    params.require(:postcode_validation).permit(:postcode)
  end
end
