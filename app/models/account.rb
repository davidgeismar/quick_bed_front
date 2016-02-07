class Account

  # simplified model in order to be able to use some useful Active Model Features (we dont need DB Features which are handled on the API)
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

# read and writte all this attributes I think attr_reader would suffice
  attr_accessor :name, :contact_mail, :contact_tel, :legal_status, :iban, :bic



# Validations
  validates :name, presence: true, length: {minimum: 2}
  validates :contact_mail, format: {
    with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: 'mauvais format mail'
  }
  validates :contact_tel, format: {
      with:     /\A(\+33)[1-9]([-. ]?[0-9]{2}){4}\z/,
      message:  'Le format de votre numéro doit être du type +33602385414'
    }
  validates :iban, presence: true, format: {
      with:     /\A[a-zA-Z]{2}\d{2}\s*(\w{4}\s*){2,7}\w{1,4}\s*\z/,
      message:  'Le format de votre IBAN doit être du type FR70 3000 2005 5000 0015 7845 Z02'
    }, allow_blank: true

  validates :bic, presence: true, format: {
      with:     /([a-zA-Z]{4}[a-zA-Z]{2}[a-zA-Z0-9]{2}([a-zA-Z0-9]{3})?)/,
      message:  'Le format de votre BIC doit être du type AXABFRPP  '
    }, allow_blank: true



  # this is necessary in order to be able to call Account.new(params[:account])
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  # we do not persist data into database here
  def persisted?
    false
  end


end
