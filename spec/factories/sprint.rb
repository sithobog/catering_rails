FactoryGirl.define do
  factory :sprint do
  	title "Test title"
  	started_at Date.new(2015,10,15)
  	finished_at Date.new(2015,10,17)
  	state "running"
  end

end
