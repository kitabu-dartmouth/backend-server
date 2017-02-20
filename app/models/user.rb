class User < ApplicationRecord
    enum role: [:user, :vip, :admin]
    after_initialize :set_default_role, :if => :new_record?

    validates_format_of :phoneno, with: /^[0-9]*$/, :multiline => true
    validates :phoneno,
        :presence => true,
        :length => {is: 10},
        :uniqueness => {
            :case_sensitive => false
        }

        def set_default_role
            self.role ||= :user
        end

        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable and :omniauthable
        devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:phoneno]
end
