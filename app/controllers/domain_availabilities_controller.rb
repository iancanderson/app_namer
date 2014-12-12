require "domainr"

class DomainAvailabilitiesController < ApplicationController
  def show
    render json: domainr_results
  end

  private

  def domainr_results
    Domainr.search(params[:app_name]).results.first(3).map do |domain|
      {
        domain: domain.domain,
        availability: domain.availability,
        register_url: domain.register_url
      }
    end
  end
end
