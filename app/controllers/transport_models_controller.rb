class TransportModelsController < ApplicationController
  def index
    @transport_models = TransportModel.all
  end
end
