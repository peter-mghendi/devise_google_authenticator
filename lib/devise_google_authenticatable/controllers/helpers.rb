require 'rqrcode'
require 'base64'

module DeviseGoogleAuthenticator
  module Controllers # :nodoc:
    module Helpers # :nodoc:
      def google_authenticator_qrcode(user, qualifier=nil, issuer=nil)
        data = "otpauth://totp/#{user.email}?secret=#{user.gauth_secret}"
        data << "&issuer=#{issuer}" unless issuer.nil?

        qrcode = RQRCode::QRCode.new(data, level: :m, mode: :byte_8bit)
        png = qrcode.as_png(fill: 'white', color: 'black', border_modules: 1, module_px_size: 4)
        url = "data:image/png;base64,#{Base64.encode64(png.to_s).strip}"

        return image_tag(url, alt: 'Google Authenticator QRCode')
      end
    end
  end
end
