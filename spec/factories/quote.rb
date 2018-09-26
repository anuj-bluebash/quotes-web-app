FactoryGirl.define do
  factory :quote do
    title { Faker::Book.title }
    content { Faker::Book.genre }
    link { Faker::Internet.url }
  end
end
