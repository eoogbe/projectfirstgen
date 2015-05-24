$(document).on "blur", "#new_user #user_email", ->
  email = $(this).val()
  if email.length > 0 and $("#user_username").val().length is 0
    candidateUsername = email.split("@")[0]
    $.ajax
      url: "/users/#{candidateUsername}"
      method: "HEAD"
      statusCode: { 404: -> $("#user_username").val candidateUsername }
