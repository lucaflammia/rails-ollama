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

  # def call_ollama(chat)
  #   # Create an empty message to stream to
  #   message = chat.messages.create(role: 'assistant', content: '')

  #   client = Ollama.new(
  #     credentials: { address: ENV['OLLAMA_API_URL'] },
  #     options: { server_sent_events: true }
  #   )

  #   client.chat(
  #     {
  #       model: 'text-summarization-model',
  #       messages: chat.messages.map { |m| { role: m.role, content: m.content } }
  #     }
  #   ) do |event, raw|
  #     message = if chat.messages.last.role == 'assistant'
  #                 chat.messages.last
  #               else
  #                 chat.messages.create(role: 'assistant', content: '')
  #               end
  #     stream_proc(message, event)
  #   end
  # end

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

    # client = Ollama.new(
    #   credentials: { address: ENV['OLLAMA_API_URL'] },
    #   options: { server_sent_events: true }
    # )

    # response_raw = client.chat(
    #   {
    #     model: 'mistral',
    #     messages: messages.map { |m| { role: m[:role], content: m[:content] } }
    #   }
    # ) do |event, raw|
    #   message = if messages.last[:role] == 'assistant'
    #               messages
    #             else
    #               messages = [ { role: 'assistant', content: '' } ]
    #             end
    #   stream_proc(message, event)
    # end

    response_raw = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages:,
        temperature: 0.0
      }
    )

    self.history['history'] << response_raw

    Rails.logger.debug response_raw
    response = JSON.parse(response_raw.to_json, object_class: OpenStruct)

    self.q_and_a << [message, response.choices[0].message.content]
    # self.q_and_a << [message, response[0].message.content]
  end

  private

  def stream_proc(message, event)
    new_content = event.dig('message', 'content')
    message = message.last[:content] + new_content if new_content
  end

  def client
    OpenAI::Client.new
  end
end
