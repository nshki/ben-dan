# frozen_string_literal: true

require 'net/http'
require 'uri'

desc('Adds line-separated words to the database from a given URL')
task(:add_words, [:url] => [:environment]) do |_task, args|
  # Setup default words source if none are passed.
  raw_gh = 'https://raw.githubusercontent.com'
  args.with_defaults(url: "#{raw_gh}/dwyl/english-words/master/words_alpha.txt")

  # Save contents of URL into a temporary text file.
  file_path = Rails.root.join('tmp/words.txt')
  content = Net::HTTP.get(URI.parse(args.url))
  words = content.split("\n")
  words.map! { |word| "#{word.strip}|#{Time.zone.now}|#{Time.zone.now}" }
  file = File.new(file_path, 'w')
  file.write(words.join("\n"))
  file.close

  # Copy contents into Postgres.
  ActiveRecord::Base.connection.execute \
    <<~SQL
      copy
        words (spelling, created_at, updated_at)
        from '#{file_path}'
        delimiter '|'
    SQL
end
