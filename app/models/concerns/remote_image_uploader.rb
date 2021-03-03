module RemoteImageUploader
  extend ActiveSupport::Concern

  def self.download_remote_file(remote_url)
     remote_file = Net::HTTP.get_response(URI.parse(remote_url))
     file = StringIO.new(remote_file.body)
   end
end
