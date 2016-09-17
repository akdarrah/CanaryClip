FactoryGirl.define do
  factory :schematic do
    character
    server
    state 'new'
    width 0
    length 0
    height 0
    file { File.new("#{Rails.root}/test/files/test.schematic") }
  end
end
