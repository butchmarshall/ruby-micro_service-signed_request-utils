[![Gem Version](https://badge.fury.io/rb/micro_service-signed_request-utils.svg)](http://badge.fury.io/rb/micro_service-signed_request-utils)
[![Build Status](https://travis-ci.org/butchmarshall/micro_service-signed_request-utils.svg?branch=master)](https://travis-ci.org/butchmarshall/micro_service-signed_request-utils)

# MicroService::SignedRequest::Utils

Utility functions to sign and validate signed request headers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'micro_service-signed_request-utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install micro_service-signed_request-utils

## Usage

To check if an authentication header is valid

```ruby
require 'micro_service/signed_request/utils'

MicroService::SignedRequest::Utils.validate("SignedRequest algorithm=...", "8bd2952b851747e8f2c937b340fed6e1.s", "SignedRequest")
```

To create a signature (not really useful except for unit testing)

```ruby
require 'micro_service/signed_request/utils'

timestamp = Time.now.to_i*1000
str = "algorithm=HmacSHA256&client_id=682a638ba74a4ff5fa6afa344b163e03.i&service_url=https%3A%2F%asdf%3A8443&timestamp=#{timestamp}";
secret = "8bd2952b851747e8f2c937b340fed6e1.s";
algorithm = "sha256";

MicroService::SignedRequest::Utils.sign(str, secret, algorithm)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/butchmarshall/micro_service-signed_request-utils.

