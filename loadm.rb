require 'csv'

csv_text = File.read('media_prod2.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Mediaowner.create!(row.to_hash)
end
