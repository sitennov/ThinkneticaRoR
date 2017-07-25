ready = ->
  $ ->
    questionsList = $(".questions-list")

    $('.edit-question-link').click (e) ->
      e.preventDefault();
      $(this).hide();
      question_id = $(this).data('questionId')
      $('form#edit-question-' + question_id).show()

    App.cable.subscriptions.create('QuestionsChannel', {
      connected: ->
        @perform 'follow'
      ,

      received: (data) ->
        questionsList.append data
    })

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
