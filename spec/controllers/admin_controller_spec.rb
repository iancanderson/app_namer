require 'rails_helper'

RSpec.describe AdminController, :type => :controller do

  describe "GET spellings" do
    it "returns http success" do
      get :spellings
      expect(response).to be_success
    end
  end

end
