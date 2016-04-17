require 'spec_helper'

describe MicroService::SignedRequest::Utils do
	it 'has a version number' do
		expect(MicroService::SignedRequest::Utils::VERSION).not_to be nil
	end

	before(:each) do
		@params = {
			algorithm: "HmacSHA256",
			client_id: "123f32342df4",
			service_url: "https://localhost.com",
			tenant_id: "5323dfdfdf678",
			timestamp: "1436646363000"
		}
		@algorithm = "sha256";
		@secret = "8bd2952b851747e8f2c937b340fed6e1.s";
		@expected = "5UuM+DZmiGwjq8s35431GAyBCV9YFBe5p2DdWb0Q/Hg=";
	end

	describe '#sign' do
		it 'should sign correctly' do
			expect(::MicroService::SignedRequest::Utils.sign(CGI::QueryString.param(@params), @secret, @algorithm)).to eq(@expected)
		end
	end
	describe '#validate' do
		before(:each) do

		end

		it 'should validate correctly' do
			@params[:timestamp] = Time.now.to_i*1000

			str = CGI::QueryString.param(@params)
			signature = ::MicroService::SignedRequest::Utils.sign(CGI::QueryString.param(@params), @secret, @algorithm)
			authorization_header = "SignedRequest #{str}&signature=#{CGI::escape(signature)}";
			expect(::MicroService::SignedRequest::Utils.validate(authorization_header, @secret)).to eq(true)
		end

		it 'should validate even though 4 minutes old' do
			@params[:timestamp] = (Time.now.to_i-(4*60))*1000 

			str = CGI::QueryString.param(@params)
			signature = ::MicroService::SignedRequest::Utils.sign(CGI::QueryString.param(@params), @secret, @algorithm)
			authorization_header = "SignedRequest #{str}&signature=#{CGI::escape(signature)}";
			expect(::MicroService::SignedRequest::Utils.validate(authorization_header, @secret)).to eq(true)
		end

		it 'should raise an ArgumentError if Authentication header 6 minutes old' do
			@params[:timestamp] = (Time.now.to_i-(6*60))*1000 

			str = CGI::QueryString.param(@params)
			signature = ::MicroService::SignedRequest::Utils.sign(CGI::QueryString.param(@params), @secret, @algorithm)
			authorization_header = "SignedRequest #{str}&signature=#{CGI::escape(signature)}";
			expect { ::MicroService::SignedRequest::Utils.validate(authorization_header, @secret) }.to raise_error(ArgumentError)
		end
	end
end
