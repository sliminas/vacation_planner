class VacationRequestsController < ApplicationController

  def index
    @requests = VacationRequest.all
  end

end
