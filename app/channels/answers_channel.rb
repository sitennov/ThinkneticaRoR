class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "questions/#{data['question_id']}/answers"
  end
end
