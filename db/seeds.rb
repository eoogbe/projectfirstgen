# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!([
  { name: "Nidia Gracia", email: "nrgracia@stanford.edu",
    password: ENV["PFG_NRGRACIA_PASSWORD"], username: "PFG_nrgracia",
    role: :admin },
  { name: "Eva Ogbe", email: "eoogbe@stanford.edu",
    password: ENV["PFG_EOOGBE_PASSWORD"], username: "PFG_eoogbe", role: :admin }
]).each(&:confirm)
