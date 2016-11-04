FactoryGirl.define do
  factory :render do
    texture_pack
    schematic
    camera_angle {CameraAngle::PRIMARY}
    samples_per_pixel 30
    state 'pending'
  end
end
