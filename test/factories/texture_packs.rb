FactoryGirl.define do
  factory :texture_pack do
    sequence(:name) {|n| "TexturePack #{n}" }
    zip_file { File.new("#{Rails.root}/test/files/Faithful.zip") }
  end
end
