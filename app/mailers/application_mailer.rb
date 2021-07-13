# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'sap-admin@storesaboutplaces.com'
  layout 'mailer'
end
