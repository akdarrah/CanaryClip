FactoryGirl.define do
  factory :render do
    schematic
    camera_angle {CameraAngle::PRIMARY}
    samples_per_pixel 30
    state 'pending'
  end
end
