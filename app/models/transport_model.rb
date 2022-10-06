class TransportModel < ApplicationRecord
  enum status: { active: 5, disabled: 10 }
end
