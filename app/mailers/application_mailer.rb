# frozen_string_literal: true

# Top-level class all mailers inherit from.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
