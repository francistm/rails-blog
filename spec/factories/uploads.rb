include ActionDispatch::TestProcess

FactoryGirl.define do
  image_path = Rails.root.join('spec/fixtures/files/file-image-fixture.jpg')
  non_image_path = Rails.root.join('spec/fixtures/files/2012-06-29-jekyll_post.md')

  factory :upload do
    association :admin

    factory :upload_with_image do
      file { fixture_file_upload(image_path, 'image/jpg', :binary) }
    end

    factory :upload_with_non_image do
      file { fixture_file_upload(non_image_path, 'text/plain') }
    end
  end
end
