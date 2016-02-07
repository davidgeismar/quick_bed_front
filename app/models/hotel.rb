class Hotel

  # simplified model in order to be able to use some useful Active Model Features (we dont need DB Features which are handled on the API)
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

# read and writte all this attributes I think attr_reader would suffice
  attr_accessor :name, :contact_mail, :contact_phone, :city, :postcode, :address, :account_id



# Validations

  validates :name, presence: true, length: { minimum: 2 }

  ## a revoir probleme contact_phone
  validates :contact_phone, format: {
      with:     /\A(\+33)[1-9]([-. ]?[0-9]{2}){4}\z/,
      message:  'Le format de votre numéro doit être du type +33602385414'
    }
  validates :contact_mail, format: {
    with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: 'mauvais format email'
  }
  validates :address, presence: true



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
