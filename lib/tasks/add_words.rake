# frozen_string_literal: true

require 'net/http'
require 'uri'

desc('Adds line-separated words to the database from a given URL')
task(:add_words, [:url] => [:environment]) do |_task, args|
  raw_gh = 'https://raw.githubusercontent.com'
  args.with_defaults(url: "#{raw_gh}/dwyl/english-words/master/words_alpha.txt")

  content = Net::HTTP.get(URI.parse(args.url))
  content.split("\n").each do |spelling|
    spelling = spelling&.strip&.downcase
    next if spelling.blank?

    Word.find_or_create_by(spelling: spelling)
    puts("Processed #{spelling}")
  end
end
