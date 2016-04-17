require "micro_service/signed_request/utils/version"
require "base64"
require "openssl"
require "cgi"
require "cgi/query_string"
require "time"

module MicroService # :nodoc:
	module SignedRequest # :nodoc:
		module Utils # :nodoc:
			module_function

			# Sign a string with a secret
			#
			# Sign a string with a secret and get the signature
			#
			# * *Args*    :
			#   - +string+ -> the string to sign
			#   - +secret+ -> the secret to use
			# * *Returns* :
			#   - the signature
			# * *Raises* :
			#   - +ArgumentError+ -> if no algorithm passed and algorithm could not be derived from the string
			#
			def sign(string, secret, algorithm = nil)
				plain = ::Base64.decode64(secret.gsub(/\.s$/,''))
				
				# if no override algorithm passed try and extract from string
				if algorithm.nil?
					paramMap = ::CGI.parse string

					if !paramMap.has_key?("algorithm")
						raise ArgumentError, "missing algorithm"
					end

					algorithm = paramMap["algorithm"].first.gsub(/^hmac/i,'')
				end
				
				hmac = ::OpenSSL::HMAC.digest(algorithm, plain, string)
				Base64::encode64(hmac).gsub(/\n$/,'')
			end

			# Validates an authorization header
			#
			# Validates that an authorization header sent by a signed request microservice
			#
			# * *Args*    :
			#   - +authorization_header+ -> the entire Authorization header sent
			#   - +client_secret+ -> the client secret to authenticate the header with
			# * *Returns* :
			#   - the signature
			# * *Raises* :
			#   - +ArgumentError+ -> if the authorization_header does not contain header_prefix
			#   - +ArgumentError+ -> if the heauthorization_header does not contain all the required parameters
			#   - +ArgumentError+ -> if the heauthorization_header has expired (more than 5 minutes old)
			#
			def validate(authorization_header, client_secret, header_prefix = "SignedRequest")
				# Validate header_prefix part of header
				if !authorization_header.match(/^#{header_prefix}/)
					raise ArgumentError, "authorization header is not properly formatted, must start with #{header_prefix}"
				end

				paramMap = ::CGI.parse authorization_header.gsub(/^#{header_prefix}\s/,'')

				# Validate all parameters are passed from header
				if !paramMap.has_key?("algorithm") ||
					!paramMap.has_key?("client_id") ||
					!paramMap.has_key?("service_url") ||
					!paramMap.has_key?("timestamp") ||
					!paramMap.has_key?("signature")
					raise ArgumentError, "authorization header is partial"
				end

				# Validate timestamp is still valid
				timestamp = Time.at(paramMap["timestamp"].first.to_i/1000)
				secondsPassed = Time.now - timestamp

				if secondsPassed < 0 || secondsPassed > (5*60)
					raise ArgumentError, "authorization is rejected since it's #{ secondsPassed } seconds old (max. allowed is 5 minutes)"
				end

				self.sign(authorization_header.gsub(/^#{header_prefix}\s/,'').gsub(/\&signature[^$]+/,''), client_secret) === paramMap["signature"].first
			end
		end
	end
end
