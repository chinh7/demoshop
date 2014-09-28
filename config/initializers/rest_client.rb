# fix RestClient::SSLCertificateNotVerified: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
# https://github.com/rest-client/rest-client/issues/288
class RestClient::Request
  def ssl_ca_file
    "/etc/ssl/certs/ca-bundle.crt"
  end
end
