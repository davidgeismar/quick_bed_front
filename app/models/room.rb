class Room

  # simplified model in order to be able to use some useful Active Model Features (we dont need DB Features which are handled on the API)
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # read and writte all this attributes I think attr_reader would suffice
  attr_accessor :name, :contact_mail, :contact_tel, :legal_status, :iban, :bic



  # Validations
  validates :content, presence: true
  validates :hotel_id, presence: true




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
