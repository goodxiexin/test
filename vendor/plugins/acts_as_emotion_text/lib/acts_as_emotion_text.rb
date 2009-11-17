# ActsAsEmotionText

module Emotion

  Symbols = ['[-_-]', '[@o@]', '[-|-]', '[o_o]', '[ToT]', '[*_*]']

  def acts_as_emotion_text(options={})
    define_method("before_create") do
      options[:columns].each do |column|
        Symbols.each_with_index do |s, i|
          eval("self.#{column}").gsub!("#{s}", "<img src='/faces/#{i}.gif'/>")
        end
      end
    end
  end

end

ActiveRecord::Base.extend(Emotion)
