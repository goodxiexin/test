module Diggable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_diggable
      has_many :digs, :as => 'diggable', :dependent => :destroy

      include Diggable::InstanceMethods

      extend Diggable::SingletonMethods
    end   

  end

  module SingletonMethods
  end

  module InstanceMethods
  end

end

ActiveRecord::Base.send(:include, Diggable)

