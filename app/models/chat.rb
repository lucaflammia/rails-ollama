# == Schema Information
#
# Table name: chats
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  history    :json
#  q_and_a    :string           default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Chat < ApplicationRecord
  belongs_to :user

  attr_accessor :message

  def message=(message)
    self.history = { prompt: message, history: [] } if history.blank?

    messages = [
      { role: 'system', content: history['prompt'] }
    ]
    q_and_a.each do |question, answer|
      messages << { role: 'user', content: question }
      messages << { role: 'assistant', content: answer }
    end
    messages << { role: 'user', content: message } if messages.size > 1

    client = Ollama.new(
      credentials: { address: ENV['OLLAMA_API_URL'] },
      options: { server_sent_events: true }
    )

    response_raw = client.chat(
      {
        model: 'gemma:2b',
        messages: messages.map { |m| { role: m[:role], content: m[:content] } }
      }
    )

    content = response_raw.map {|r| r['message']['content']}.join
    res = { model: 'mistral', message: { role: "assistant", content: } }

    self.history['history'] << res

    Rails.logger.debug res
    response = JSON.parse(res.to_json, object_class: OpenStruct)

    self.q_and_a << [message, response.message.content]
  end
end
