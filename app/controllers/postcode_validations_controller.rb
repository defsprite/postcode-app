# frozen_string_literal: true

class PostcodeValidationsController < ApplicationController
  def new
    @postcode_validation =  PostcodeValidation.new
  end

  def create
  end
end
