FactoryGirl.define do
  factory :block do
    sequence(:minecraft_id) {|n| n }
    sequence(:name) {|n| "block_#{n}" }
    sequence(:display_name) {|n| "Block ##{n}" }
    stack_size 64
    diggable true
    bounding_box 'empty'
    transparent true
    emit_light 0
    filter_light 0
    hardness 0
  end
end
