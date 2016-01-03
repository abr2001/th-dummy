window.App = {}

window.App.utils = 
  successMessage: (message) ->
    return unless message
    Materialize.toast(message, 2000, 'green')

  errorMessage: (message) ->
    return unless message
    Materialize.toast(message, 4000, 'red')

  ajaxErrorHandler: (e, data) ->
    message = 'Unknown error'
    if data.status == 401
      message = 'Sign in, please'
    else if data.status == 404
      message = 'Not found'
    else if data.status >= 400 && data.status < 500
      message = data.responseText

    App.utils.errorMessage message