require 'rails_helper'

describe QuotesController do
  let(:quote) { FactoryGirl.create(:quote) }

  describe "#random" do
    before do
      stub_request(:get, "http://quotesondesign.com/wp-json/posts?filter%5Borderby%5D=rand&filter%5Bposts_per_page%5D=1").
       with(
         headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v0.9.2'
         }).
       to_return(status: 200, body: "[{\"ID\":2463,\"title\":\"Ant xupery\",\"content\":\"<p>If you wasea.<\\/p>\\n\",\"link\":\"https:\\/\\/quotesondesign.com\\/-4\\/\"}]", headers: {})
    end

    context "quote" do
      it "returns a correct status code" do
        get :random
        expect(assigns(:quotes).count).to eq_to(1)
        expect(response.status).to eq 200
      end
    end

    context "quote failed" do
      before do
        stub_request(:get, "http://quotesondesign.com/wp-json/posts?filter%5Borderby%5D=rand&filter%5Bposts_per_page%5D=1").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v0.9.2'
           }).
         to_return(status: 200, body: "", headers: {})
      end

      it "should fail to fetch and store quotes" do
        get :random
        expect(Quote.count).to eq 0
        expect(assigns(:quotes).count).to eq_to(0)
        expect(response.status).to eq 200
      end

      it "should return existing quote from db" do
        get :random
        quote
        expect(Quote.count).to eq 1
        expect(assigns(:quotes).count).to eq_to(1)
        expect(response.status).to eq 200
      end 
    end
  end
end