source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'
gem 'pg', '~> 0.18'
gem 'activerecord-precount'

gem 'trailblazer-rails'
gem 'trailblazer-cells'
gem 'reform', '2.3.0.rc1'
gem 'reform-rails', '0.2.0.rc1'
gem 'slim-rails'

gem 'rfc822'

gem 'devise'
gem 'holidays'

gem 'delayed_job_active_record'

gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem'
gem 'sass-rails', '~> 5.0'

gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'mini_racer'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'


gem 'puma', '~> 3.7'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'phantomjs'
  gem 'shoulda'
  gem 'shoulda-context'
  gem 'poltergeist'
  gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'daemons'
  gem 'web-console', '>= 3.3.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
