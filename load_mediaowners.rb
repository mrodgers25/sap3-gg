require 'csv'

csv_text = File.read('MediaOwner.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Mediaowner.create!(row.to_hash)
end
