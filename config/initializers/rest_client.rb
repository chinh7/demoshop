
# fix RestClient::SSLCertificateNotVerified: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
# https://github.com/rest-client/rest-client/issues/288
if Rails.env.production?
  class RestClient::Request
    def ssl_ca_file
      ENV["SSL_CERT_FILE"] || "/etc/ssl/certs/ca-bundle.crt"
    end
  end
end
