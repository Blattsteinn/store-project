if Rails.env.development?
  require "letter_opener"

  module LetterOpener
    class DeliveryMethod
      def deliver!(mail)
        validate_mail!(mail)
        location = File.join(settings[:location], "#{Time.now.to_f.to_s.tr('.', '_')}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
        messages = Message.rendered_messages(mail, location: location, message_template: settings[:message_template])
        filepath = messages.first.filepath
        windows_path = `wslpath -m "#{filepath}"`.strip
        file_url = "file://#{windows_path}"
        system("/bin/bash -c '\"/mnt/c/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe\" \"#{file_url}\"'")
      end
    end
  end
end