clearForm = ($form) ->
  $form.find(":input").not(":submit").val ""
  $form.find(".form-control.error + .help-block").remove()
  $form.find(".error").removeClass "has-error error"

replaceWithErrorForm = (e, xhr) -> $(this).replaceWith xhr.responseText

$(document)
  .on "ajax:success", "#new_comment", (e, data) ->
    $("#comments").prepend data
    clearForm $(this)
    $("html,body").animate { scrollTop: $("#comments").offset().top }, "slow"
  .on "ajax:error", "#new_comment", replaceWithErrorForm
  .on "ajax:success", ".reply-link", (e, data) ->
    $form = $(data)
    $(this).replaceWith $form
    console.log $form.find(":input")
    $form.find(".form-control:first").focus()
  .on "ajax:success", ".formtastic.reply", (e, data) ->
    $(this).closest(".comment").find(".replies").append data
    clearForm $(this)
  .on "ajax:error", ".formtastic.reply", replaceWithErrorForm
